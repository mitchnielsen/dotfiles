import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { mkdtempSync, rmSync } from "node:fs";
import { createRequire } from "node:module";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { test } from "node:test";
import { fileURLToPath, pathToFileURL } from "node:url";
import { stripVTControlCharacters } from "node:util";
import type {
  ExecOptions,
  ExecResult,
  ExtensionAPI,
  ExtensionContext,
  ExtensionFactory,
  SessionEntry,
  ToolResultEvent,
} from "@earendil-works/pi-coding-agent";

const piPackage = join(
  execFileSync("brew", ["--prefix", "pi-coding-agent"], { encoding: "utf8" }).trim(),
  "libexec/lib/node_modules/@earendil-works/pi-coding-agent",
);
const hostRequire = createRequire(join(piPackage, "package.json"));
const { createJiti } = hostRequire("jiti");
const jiti = createJiti(import.meta.url, {
  moduleCache: false,
  alias: {
    "@earendil-works/pi-tui": hostRequire.resolve("@earendil-works/pi-tui"),
  },
});
const extensionPath = join(dirname(fileURLToPath(import.meta.url)), "../extensions/session-prs.ts");
const sessionPrExtension: ExtensionFactory = await jiti.import(extensionPath, { default: true });
const { hyperlink, visibleWidth } = await jiti.import(hostRequire.resolve("@earendil-works/pi-tui"));

type EventHandler = (event: unknown, ctx: ExtensionContext) => unknown;

function createHarness(mode: ExtensionContext["mode"] = "tui") {
  const entries: SessionEntry[] = [];
  const handlers = new Map<string, EventHandler>();
  const statuses = new Map<string, string>();
  const notifications: { message: string; level: string }[] = [];
  const executions: { command: string; args: string[]; options?: ExecOptions }[] = [];
  const results: ExecResult[] = [];
  const ctx = {
    cwd: "/workspace/repo",
    mode,
    hasUI: mode === "tui" || mode === "rpc",
    sessionManager: { getEntries: () => entries, getBranch: () => [] },
    ui: {
      setStatus(key: string, value: string | undefined) {
        if (value === undefined) statuses.delete(key);
        else statuses.set(key, value);
      },
      notify(message: string, level: string) {
        notifications.push({ message, level });
      },
    },
  } as unknown as ExtensionContext;
  const pi = {
    on(name: string, handler: EventHandler) {
      handlers.set(name, handler);
    },
    registerCommand() {},
    appendEntry(customType: string, data: unknown) {
      entries.push({
        type: "custom", customType, data,
        id: `entry-${entries.length}`, parentId: null, timestamp: new Date().toISOString(),
      });
    },
    async exec(command: string, args: string[], options?: ExecOptions) {
      executions.push({ command, args, options });
      assert.ok(results.length > 0, "Unexpected external command");
      return results.shift()!;
    },
  } as unknown as ExtensionAPI;
  sessionPrExtension(pi);

  return {
    pi, ctx, entries, statuses, notifications, executions, results,
    async emit(name: string, event: unknown = {}) {
      const handler = handlers.get(name);
      assert.ok(handler, `Missing handler: ${name}`);
      return handler(event, ctx);
    },
    async bash(command: string, output: string, extra: Partial<ToolResultEvent> = {}) {
      return handlers.get("tool_result")!({
        type: "tool_result", toolName: "bash", toolCallId: "call-1",
        input: { command }, content: [{ type: "text", text: output }], isError: false,
        ...extra,
      }, ctx);
    },
    urls() {
      return entries.filter((entry) => entry.type === "custom" && entry.customType === "session-pr")
        .map((entry) => (entry as { data: { url: string } }).data.url);
    },
    status() { return stripVTControlCharacters(statuses.get("session-pr") ?? ""); },
  };
}

function appendSavedBash(
  h: ReturnType<typeof createHarness>,
  command: string,
  output: string,
  isError = false,
) {
  const id = `saved-${h.entries.length}`;
  const timestamp = Date.now();
  h.entries.push({
    type: "message", id, parentId: null, timestamp: new Date(timestamp).toISOString(),
    message: {
      role: "assistant", api: "openai-responses", provider: "openai", model: "test",
      content: [{ type: "toolCall", id, name: "bash", arguments: { command } }],
      stopReason: "toolUse", timestamp,
      usage: {
        input: 0, output: 0, cacheRead: 0, cacheWrite: 0, totalTokens: 0,
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 },
      },
    },
  }, {
    type: "message", id: `${id}-result`, parentId: id,
    timestamp: new Date(timestamp).toISOString(),
    message: {
      role: "toolResult", toolCallId: id, toolName: "bash", isError, timestamp,
      content: [{ type: "text", text: output }],
    },
  });
}

function success(stdout = ""): ExecResult {
  return { code: 0, stdout, stderr: "", killed: false };
}

test("loads through Pi's extension loader", async () => {
  const { loadExtensions } = await import(pathToFileURL(join(piPackage, "dist/core/extensions/loader.js")).href);
  const loaded = await loadExtensions([extensionPath], process.cwd());
  assert.deepEqual(loaded.errors, []);
  assert.equal(loaded.extensions.length, 1);
  assert.equal(loaded.extensions[0].commands.size, 0);
  assert.equal(loaded.extensions[0].tools.size, 0);
});

test("records gh pr create output and adds a clickable footer link", async () => {
  const h = createHarness();
  await h.bash("gh pr create --draft --assignee=@me", "Creating pull request...\nhttps://github.com/Owner/Repo/pull/123/\n");
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
  assert.equal(h.status(), "PRs: #123");
  assert.ok(h.statuses.get("session-pr")!.includes(hyperlink("#123", h.urls()[0])));
  assert.equal(h.executions.length, 0);
});

test("records the heredoc PR-creation pattern used by the affected sessions", async () => {
  const h = createHarness();
  await h.bash(
    `cd /workspace/platform/feature && gh pr create --base main --head feature --title "feat: route alerts" --body-file - <<'EOF'
Depends on https://github.com/owner/platform/pull/99
A description can mention commands such as:
gh pr view 99
(These lines are PR body text.)
EOF`,
    "https://github.com/owner/platform/pull/123\n",
  );
  assert.deepEqual(h.urls(), ["https://github.com/owner/platform/pull/123"]);
  assert.equal(h.status(), "PRs: #123");
});

test("accepts repository checks and git push before heredoc PR creation", async () => {
  const h = createHarness();
  await h.bash(
    `cd /workspace/repo/feature && git status --short --branch && gh repo view --json nameWithOwner,defaultBranchRef && git push --set-upstream origin HEAD && gh pr create --base main --title "fix: adapter pooling" --body-file - <<'EOF'
Related to #99
EOF`,
    `## feature
{"nameWithOwner":"owner/repo","defaultBranchRef":{"name":"main"}}
remote: https://github.com/owner/repo/pull/new/feature
https://github.com/owner/repo/pull/123`,
  );
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("handles unquoted, double-quoted, and tab-stripped heredoc delimiters", async () => {
  for (const header of ["<<EOF", '<<"EOF"', "<<-'EOF'"]) {
    const h = createHarness();
    const tab = header.includes("<<-") ? "\t" : "";
    await h.bash(
      `gh pr create --body-file - ${header}\n${tab}gh pr view 99\n${tab}EOF\n`,
      "https://github.com/owner/repo/pull/123",
    );
    assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
  }
});

test("ignores a preparatory heredoc body and follows commands after its delimiter", async () => {
  const h = createHarness();
  await h.bash(
    `cat > /tmp/pr-body.md <<'EOF'
gh pr view 99
https://github.com/owner/repo/pull/99
EOF
gh pr create --body-file /tmp/pr-body.md`,
    "https://github.com/owner/repo/pull/123",
  );
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("handles continued PR arguments and shell comments", async () => {
  const h = createHarness();
  await h.bash(
    "# gh pr view 99\ngh pr create \\\n  --draft \\\n  --body-file - <<'EOF' # PR description\ngh pr view 99\nEOF",
    "https://github.com/owner/repo/pull/123",
  );
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("records nested bash calls even when codemode does not print their output", async () => {
  const h = createHarness();
  await h.bash("gh pr create --fill", "https://github.com/owner/repo/pull/456", {
    toolCallId: "codemode-1/1", parentToolCallId: "codemode-1",
  });
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/456"]);
});

test("reads the full structured output when visible tool output is truncated", async () => {
  const h = createHarness();
  await h.bash("gh pr create --fill", "[output truncated]", {
    structuredContent: { output: "https://github.com/owner/repo/pull/123\n", exit_code: 0 },
  });
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("ignores PRs viewed, edited, checked out, mentioned, or returned by failed creation", async () => {
  const h = createHarness();
  const url = "https://github.com/owner/repo/pull/123";
  for (const command of [
    "gh pr view 123", "gh pr edit 123", "gh pr checkout 123", "gh stack view --json",
    "echo 'gh pr create'", "# gh pr create\nprintf '%s' url", "gh pr create --help",
  ]) {
    await h.bash(command, command.endsWith("--help") ? "Create a pull request" : url);
  }
  await h.bash("gh pr create --fill", url, { isError: true });
  await h.bash("gh pr create --fill", url, { toolName: "read" });
  assert.deepEqual(h.urls(), []);
  assert.equal(h.executions.length, 0);
});

test("does not attach viewed or echoed PRs from mixed shell output", async () => {
  const h = createHarness();
  const output = "https://github.com/owner/repo/pull/99\nhttps://github.com/owner/repo/pull/123";
  await h.bash("gh pr view 99 --json url --jq .url && gh pr create --fill", output);
  await h.bash("gh pr create --fill && gh pr view 99 --json url --jq .url", output);
  await h.bash("gh pr create --fill; printf '%s\\n' 'https://github.com/owner/repo/pull/99'", output);
  assert.deepEqual(h.urls(), []);
  assert.match(h.notifications.at(-1)!.message, /No PR links were recorded/);
});

test("does not infer PR creation from heredoc text or complex shell context", async () => {
  const h = createHarness();
  await h.bash(
    "cat <<'EOF'\ngh pr create\nEOF\necho https://github.com/owner/repo/pull/99",
    "gh pr create\nhttps://github.com/owner/repo/pull/99",
  );
  await h.bash("(cd /other/repo && gh stack submit --auto)", "Created PR #123 for api");
  await h.bash("export GH_REPO=other/project; gh stack submit --auto", "Created PR #123 for api");
  assert.deepEqual(h.urls(), []);
  assert.equal(h.executions.length, 0);
});

test("records multiple creation commands in one bash call", async () => {
  const h = createHarness();
  await h.bash(
    "gh pr create --head api --fill && gh pr create --head ui --fill",
    "https://github.com/owner/repo/pull/123\nhttps://github.com/owner/repo/pull/456",
  );
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123", "https://github.com/owner/repo/pull/456"]);
});

test("tracks only newly created stack PRs and resolves their URLs once", async () => {
  const h = createHarness();
  h.results.push(success("https://github.com/owner/repo/pull/123\n"), success("https://github.com/owner/repo/pull/456\n"));
  await h.bash("gh stack submit --auto", "Updated PR #99 for existing\n✓ Created PR #123 for api\n✓ Created PR #456 for ui\n");
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123", "https://github.com/owner/repo/pull/456"]);
  assert.deepEqual(h.executions.map((call) => call.args), [
    ["pr", "view", "123", "--json", "url", "--jq", ".url"],
    ["pr", "view", "456", "--json", "url", "--jq", ".url"],
  ]);
});

test("uses stack output hyperlinks without querying GitHub", async () => {
  const h = createHarness();
  await h.bash("gh stack submit --auto", `✓ Created PR ${hyperlink("#123", "https://github.com/owner/repo/pull/123")} for api`);
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
  assert.equal(h.executions.length, 0);
});

test("preserves created stack PRs when a later submit step fails", async () => {
  const h = createHarness();
  h.results.push(success("https://github.com/owner/repo/pull/123"));
  await h.bash("gh stack submit --auto", "Created PR #123 for api\nFailed to update stack", { isError: true });
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("resolves stack numbers in the command's repository and working directory", async () => {
  const h = createHarness();
  h.results.push(success("https://github.com/other/project/pull/123"));
  await h.bash('cd "../other project" && gh --repo other/project stack submit --auto', "Created PR #123 for api");
  assert.equal(h.executions[0].options!.cwd, "/workspace/other project");
  assert.deepEqual(h.executions[0].args.slice(-2), ["--repo", "other/project"]);
  assert.deepEqual(h.urls(), ["https://github.com/other/project/pull/123"]);
});

test("preserves an inline GH_REPO when resolving stack numbers", async () => {
  const h = createHarness();
  h.results.push(success("https://github.com/other/project/pull/123"));
  await h.bash("env GH_REPO=other/project gh stack submit --auto", "Created PR #123 for api");
  assert.deepEqual(h.executions[0].args.slice(-2), ["--repo", "other/project"]);
  assert.deepEqual(h.urls(), ["https://github.com/other/project/pull/123"]);
});

test("does not guess a repository when cd uses shell expansion", async () => {
  const h = createHarness();
  await h.bash('cd "$WORKTREE" && gh stack submit --auto', "Created PR #123 for api");
  assert.deepEqual(h.urls(), []);
  assert.equal(h.executions.length, 0);
});

test("supports repository flags after the PR subcommand", async () => {
  const h = createHarness();
  await h.bash("gh pr create --repo=other/project --fill", "https://github.com/other/project/pull/123");
  assert.deepEqual(h.urls(), ["https://github.com/other/project/pull/123"]);
});

test("reports a failed stack URL lookup without changing the tool result", async () => {
  const h = createHarness();
  h.results.push({ ...success(), code: 1, stderr: "Not found" });
  const result = await h.bash("gh stack submit --auto", "Created PR #123 for api");
  assert.equal(result, undefined);
  assert.deepEqual(h.urls(), []);
  assert.match(h.notifications[0].message, /Could not resolve the URL/);
  assert.equal(h.notifications[0].level, "warning");
});

test("normalizes and deduplicates created PR URLs", async () => {
  const h = createHarness();
  await h.bash("gh pr create --fill", "https://github.com/Owner/Repo/pull/123/?tab=overview#issuecomment-1");
  await h.bash("gh pr create --fill", "https://github.com/owner/repo/pull/123");
  await h.bash("gh pr create --fill", "https://github.com/OWNER/REPO/pull/123");
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("rejects unsafe and malformed PR URLs in creation output", async () => {
  const h = createHarness();
  for (const url of [
    "javascript:alert(1)", "http://github.com/owner/repo/pull/123",
    "https://github.com.evil.test/owner/repo/pull/123",
    "https://user@github.com/owner/repo/pull/123",
    "https://github.com:8443/owner/repo/pull/123",
    "https://github.com/owner/repo/issues/123",
    "https://github.com/owner/repo/pull/0",
    "https://github.com/owner/repo/pull/123 extra",
  ]) {
    await h.bash("gh pr create --fill", url);
  }
  assert.deepEqual(h.urls(), []);
  assert.equal(h.statuses.size, 0);
});

test("includes a clickable footer link for every recorded PR", async () => {
  const h = createHarness();
  for (const number of [123, 456, 789, 1000, 1001]) {
    await h.bash("gh pr create --fill", `https://github.com/owner/repo/pull/${number}`);
  }
  assert.equal(h.status(), "PRs: #123 #456 #789 #1000 #1001");
  for (const url of h.urls()) {
    const number = url.split("/").at(-1)!;
    assert.ok(h.statuses.get("session-pr")!.includes(hyperlink(`#${number}`, url)));
  }
  assert.equal(h.executions.length, 0);
});

test("restores saved links on resume and reload without GitHub calls", async () => {
  const original = createHarness();
  await original.bash("gh pr create --fill", "https://github.com/owner/repo/pull/123");
  const resumed = createHarness();
  resumed.entries.push(...JSON.parse(JSON.stringify(original.entries)));
  await resumed.emit("session_start", { reason: "resume" });
  assert.equal(resumed.status(), "PRs: #123");
  await resumed.emit("session_start", { reason: "reload" });
  assert.equal(resumed.status(), "PRs: #123");
  assert.equal(resumed.executions.length, 0);
  assert.equal(resumed.entries.length, 1);
});

test("recovers missed creation results on resume without adding body or viewed PR links", async () => {
  const h = createHarness();
  appendSavedBash(h, "gh pr view 99 --json url --jq .url", "https://github.com/owner/platform/pull/99");
  appendSavedBash(h,
    "gh pr create --body-file - <<'EOF'\nRelated to https://github.com/owner/platform/pull/99\nEOF",
    "https://github.com/owner/platform/pull/123",
  );
  appendSavedBash(h,
    "gh pr create --body-file - <<'EOF'\nDepends on #123\nEOF",
    "https://github.com/owner/flows/pull/456",
  );
  appendSavedBash(h, "gh pr create --fill", "https://github.com/owner/platform/pull/999", true);
  await h.emit("session_start", { reason: "resume" });
  assert.deepEqual(h.urls(), ["https://github.com/owner/platform/pull/123", "https://github.com/owner/flows/pull/456"]);
  assert.equal(h.status(), "PRs: #123 #456");
  assert.equal(h.executions.length, 0);
  await h.emit("session_start", { reason: "reload" });
  assert.equal(h.urls().length, 2);
});

test("recovery correlates parallel tool results with their own commands", async () => {
  const h = createHarness();
  appendSavedBash(h, "gh pr create --fill", "https://github.com/owner/repo/pull/123");
  appendSavedBash(h, "gh pr view 99", "https://github.com/owner/repo/pull/99");
  const [createCall, createResult, viewCall, viewResult] = h.entries;
  h.entries.splice(0, h.entries.length, createCall, viewCall, viewResult, createResult);
  await h.emit("session_start", { reason: "resume" });
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("saved stack creation results do not duplicate persisted links on reload", async () => {
  const h = createHarness();
  appendSavedBash(h, "gh stack submit --auto", "Created PR #123 for api");
  h.results.push(success("https://github.com/owner/repo/pull/123"));
  await h.emit("session_start", { reason: "resume" });
  h.results.push(success("https://github.com/owner/repo/pull/123"));
  await h.emit("session_start", { reason: "reload" });
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
});

test("recovery uses saved results when the creation preceded compaction or branching", async (t) => {
  const { SessionManager } = await import(pathToFileURL(join(piPackage, "dist/core/session-manager.js")).href);
  const directory = mkdtempSync(join(tmpdir(), "pi-session-prs-recovery-"));
  t.after(() => rmSync(directory, { recursive: true, force: true }));
  const history = createHarness();
  appendSavedBash(history,
    "gh pr create --body-file - <<'EOF'\nRelated to #99\nEOF",
    "https://github.com/owner/repo/pull/123",
  );
  const manager = SessionManager.create(directory, directory);
  const root = manager.appendMessage({ role: "user", content: "Create a PR", timestamp: Date.now() });
  for (const entry of history.entries) {
    if (entry.type === "message") manager.appendMessage(entry.message);
  }
  const recent = manager.appendMessage({ role: "user", content: "Continue", timestamp: Date.now() });
  manager.appendCompaction("Earlier work", recent, 10000);
  manager.branch(root);
  manager.appendMessage({ role: "user", content: "Another approach", timestamp: Date.now() });
  const h = createHarness();
  const recoveredManager = SessionManager.open(manager.getSessionFile());
  h.ctx.sessionManager = recoveredManager;
  h.pi.appendEntry = (type, data) => { recoveredManager.appendCustomEntry(type, data); };
  await h.emit("session_start", { reason: "resume" });
  assert.equal(h.status(), "PRs: #123");
  const restored = createHarness();
  restored.ctx.sessionManager = SessionManager.open(manager.getSessionFile());
  await restored.emit("session_start", { reason: "resume" });
  assert.equal(restored.status(), "PRs: #123");
  assert.equal(restored.executions.length, 0);
});

test("survives persisted session compaction and conversation branching", async (t) => {
  const { SessionManager } = await import(pathToFileURL(join(piPackage, "dist/core/session-manager.js")).href);
  const directory = mkdtempSync(join(tmpdir(), "pi-session-prs-"));
  t.after(() => rmSync(directory, { recursive: true, force: true }));
  const manager = SessionManager.create(directory, directory);
  const root = manager.appendMessage({ role: "user", content: "Create a PR", timestamp: Date.now() });
  const h = createHarness();
  h.ctx.sessionManager = manager;
  h.pi.appendEntry = (type, data) => { manager.appendCustomEntry(type, data); };
  await h.bash("gh pr create --fill", "https://github.com/owner/repo/pull/123");
  const recent = manager.appendMessage({ role: "user", content: "Continue", timestamp: Date.now() });
  manager.appendCompaction("Earlier work", recent, 10000);
  await h.emit("session_start", { reason: "reload" });
  assert.equal(h.status(), "PRs: #123");
  manager.branch(root);
  manager.appendMessage({ role: "user", content: "Another approach", timestamp: Date.now() });
  assert.equal(manager.getBranch().some((entry: SessionEntry) => entry.type === "custom"), false);
  const resumed = createHarness();
  resumed.ctx.sessionManager = SessionManager.open(manager.getSessionFile());
  await resumed.emit("session_start", { reason: "resume" });
  assert.equal(resumed.status(), "PRs: #123");
  assert.equal(resumed.executions.length, 0);
});

test("includes PRs from all conversation branches and clears links for a new session", async () => {
  const h = createHarness();
  await h.bash("gh pr create --fill", "https://github.com/owner/repo/pull/123");
  await h.emit("session_start", { reason: "reload" });
  assert.equal(h.status(), "PRs: #123");
  h.entries.length = 0;
  await h.emit("session_start", { reason: "new" });
  assert.equal(h.statuses.has("session-pr"), false);
});

test("ignores invalid persisted entries and unrelated extension metadata", async () => {
  const h = createHarness();
  h.pi.appendEntry("session-pr", null);
  h.pi.appendEntry("session-pr", { url: 123 });
  h.pi.appendEntry("session-pr", { url: "https://evil.test/owner/repo/pull/123" });
  h.pi.appendEntry("other-extension", { url: "https://github.com/owner/repo/pull/123" });
  await h.emit("session_start", { reason: "resume" });
  assert.equal(h.statuses.has("session-pr"), false);
});

test("links identical PR numbers to their respective repositories", async () => {
  const h = createHarness();
  await h.bash("gh pr create --fill", "https://github.com/owner/one/pull/123");
  await h.bash("gh pr create --fill", "https://github.com/owner/two/pull/123");
  assert.deepEqual(h.urls(), ["https://github.com/owner/one/pull/123", "https://github.com/owner/two/pull/123"]);
  for (const url of h.urls()) {
    assert.ok(h.statuses.get("session-pr")!.includes(hyperlink("#123", url)));
  }
  assert.equal(h.executions.length, 0);
});

test("records PRs in non-interactive mode without accessing terminal UI", async () => {
  const h = createHarness("print");
  await h.bash("gh pr create --fill", "https://github.com/owner/repo/pull/123");
  assert.deepEqual(h.urls(), ["https://github.com/owner/repo/pull/123"]);
  assert.equal(h.statuses.size, 0);
});

test("the existing footer fits PR hyperlinks at narrow and wide widths", async () => {
  const h = createHarness();
  for (const number of [123, 456, 789, 1000, 1001]) {
    await h.bash("gh pr create --fill", `https://github.com/owner/repo/pull/${number}`);
  }
  let footer: { render(width: number): string[] } | undefined;
  h.ctx.ui.setFooter = (factory) => {
    assert.ok(factory);
    footer = factory(
      { requestRender() {} } as never,
      { fg(_color: string, text: string) { return text; } } as never,
      { getExtensionStatuses: () => h.statuses } as never,
    );
  };
  h.ctx.getContextUsage = () => undefined;
  h.pi.getSessionName = () => "Session PR test";
  h.results.push(success());
  const customFooter: ExtensionFactory = await jiti.import(join(dirname(extensionPath), "custom-footer.ts"), { default: true });
  customFooter(h.pi);
  await h.emit("session_start");
  assert.ok(footer);
  for (const width of [1, 5, 10, 20, 40, 80, 120]) {
    for (const line of footer.render(width)) {
      assert.ok(visibleWidth(line) <= width, `Footer exceeded ${width} columns`);
    }
  }
});
