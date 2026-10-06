import { homedir } from "node:os";
import { basename, resolve } from "node:path";
import { stripVTControlCharacters } from "node:util";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { hyperlink } from "@earendil-works/pi-tui";

const PR_ENTRY_TYPE = "session-pr";
const FOOTER_PR_LIMIT = 3;

interface SessionPr {
  url: string;
  repo: string;
  number: string;
}

function parseSessionPr(value: unknown): SessionPr | undefined {
  if (typeof value !== "string") return;

  let url: URL;
  try {
    url = new URL(value.trim());
  } catch {
    return;
  }

  if (
    url.protocol !== "https:" ||
    url.hostname !== "github.com" ||
    url.port ||
    url.username ||
    url.password
  ) {
    return;
  }

  const match = url.pathname.match(
    /^\/([\w.-]+)\/([\w.-]+)\/pull\/([1-9]\d*)\/?$/,
  );
  if (!match) return;

  const repo = `${match[1]}/${match[2]}`.toLowerCase();
  const number = match[3];
  return { url: `https://github.com/${repo}/pull/${number}`, repo, number };
}

function creationContext(command: string, cwd: string) {
  const lexer = /'[^']*'|"(?:\\[\s\S]|[^"\\])*"|\\\r?\n|#[^\r\n]*|<<<|\d*<<-?|&&|\|\||[;&|()\n]|[^\s'";&|()<]+/g;
  const tokens: string[] = [];
  const heredocs: { delimiter: string; stripTabs: boolean }[] = [];
  for (let match = lexer.exec(command); match; match = lexer.exec(command)) {
    const token = match[0];
    if (token.startsWith("#") || /^\\\r?\n$/.test(token)) continue;
    if (/^\d*<<-?$/.test(token)) {
      const delimiter = lexer.exec(command)?.[0];
      if (!delimiter || /^(?:&&|\|\||[;&|()\n]|<<<|\d*<<-?)$/.test(delimiter)) return;
      heredocs.push({
        delimiter: delimiter.replace(/^(['"])([\s\S]*)\1$/, "$2"),
        stripTabs: token.endsWith("-"),
      });
      continue;
    }
    tokens.push(token);
    if (token !== "\n") continue;

    // Heredoc bodies are stdin, so their links and commands are excluded.
    for (const heredoc of heredocs) {
      let closed = false;
      while (lexer.lastIndex < command.length) {
        const nextLine = command.indexOf("\n", lexer.lastIndex);
        const end = nextLine === -1 ? command.length : nextLine;
        let line = command.slice(lexer.lastIndex, end).replace(/\r$/, "");
        lexer.lastIndex = nextLine === -1 ? end : end + 1;
        if (heredoc.stripTabs) line = line.replace(/^\t+/, "");
        if (line === heredoc.delimiter) {
          closed = true;
          break;
        }
      }
      if (!closed) return;
    }
    heredocs.length = 0;
  }
  if (heredocs.length || tokens.some((token) => /^(?:[()]|<<<)$/.test(token))) return;
  let words: string[] = [];
  let creation: {
    kind: string;
    cwd: string;
    repo?: string;
    count: number;
  } | undefined;

  for (const token of [...tokens, ";"]) {
    if (!/^(?:&&|\|\||[;&|()\n])$/.test(token)) {
      words.push(token.replace(/^(['"])([\s\S]*)\1$/, "$2"));
      continue;
    }

    if (
      words[0] === "pushd" || words[0] === "popd" ||
      (words[0] === "export" && words.some((word) => /^GH_(?:REPO|HOST)=/.test(word)))
    ) return;
    if (words[0] === "cd") {
      const operand = words[1] === "--" ? 2 : 1;
      const directory = words[operand] ?? "~";
      if (
        words.length > operand + 1 ||
        token === "||" ||
        directory.startsWith("-") ||
        /[\$`\\]/.test(directory)
      ) {
        return;
      }
      cwd = resolve(
        cwd,
        directory === "~" || directory.startsWith("~/")
          ? homedir() + directory.slice(1)
          : directory,
      );
    }

    let repo: string | undefined;
    if (words[0] === "env") words.shift();
    while (words[0] === "command" || /^[A-Za-z_]\w*=/.test(words[0] ?? "")) {
      const prefix = words.shift()!;
      if (prefix.startsWith("GH_REPO=")) repo = prefix.slice("GH_REPO=".length);
      if (prefix.startsWith("GH_HOST=") && prefix !== "GH_HOST=github.com") return;
    }

    if (words[0] && basename(words[0]) === "gh") {
      const args: string[] = [];
      for (let i = 1; i < words.length; i++) {
        if (words[i] === "-R" || words[i] === "--repo") {
          repo = words[++i];
        } else if (words[i].startsWith("--repo=")) {
          repo = words[i].slice("--repo=".length);
        } else if (words[i].startsWith("-R")) {
          repo = words[i].slice(2);
        } else {
          args.push(words[i]);
        }
      }

      if (args[0] === "repo" && args[1] === "view") {
        words = [];
        continue;
      }
      if (
        !(
          (args[0] === "pr" && args[1] === "create") ||
          (args[0] === "stack" && args[1] === "submit")
        ) ||
        args.includes("--help") ||
        args.includes("-h")
      ) {
        return;
      }
      if (repo && !/^(?:github\.com\/)?[\w.-]+\/[\w.-]+$/.test(repo)) return;
      if (creation) {
        if (
          creation.kind !== args[0] ||
          creation.cwd !== cwd ||
          creation.repo !== repo
        ) {
          return;
        }
        creation.count++;
      } else {
        creation = { kind: args[0], cwd, repo, count: 1 };
      }
    }
    words = [];
  }
  return creation;
}

export default function sessionPrExtension(pi: ExtensionAPI) {
  const prs = new Map<string, SessionPr>();
  const processedCalls = new Set<string>();

  function updatePrStatus(ctx: ExtensionContext) {
    if (ctx.mode !== "tui") return;
    if (prs.size === 0) {
      ctx.ui.setStatus(PR_ENTRY_TYPE, undefined);
      return;
    }

    const links = [...prs.values()]
      .slice(0, FOOTER_PR_LIMIT)
      .map((pr) => hyperlink(`#${pr.number}`, pr.url));
    const remaining = prs.size - links.length;
    ctx.ui.setStatus(
      PR_ENTRY_TYPE,
      `PRs: ${links.join(" ")}${remaining > 0 ? ` +${remaining}` : ""} (/prs)`,
    );
  }

  function addSessionPr(pr: SessionPr, ctx: ExtensionContext) {
    if (prs.has(pr.url)) return false;
    pi.appendEntry(PR_ENTRY_TYPE, { url: pr.url });
    prs.set(pr.url, pr);
    updatePrStatus(ctx);
    return true;
  }

  async function recordPrCreation(
    command: string,
    output: string,
    isError: boolean,
    ctx: ExtensionContext,
  ) {
    const creation = creationContext(command, ctx.cwd);
    if (!creation) return;

    if (creation.kind === "pr") {
      if (isError) return;
      const candidates = new Map<string, SessionPr>();
      for (const line of stripVTControlCharacters(output).split(/\r?\n/)) {
        const pr = parseSessionPr(line);
        if (pr) candidates.set(pr.url, pr);
      }
      if (candidates.size <= creation.count) {
        for (const pr of candidates.values()) addSessionPr(pr, ctx);
      } else if (ctx.hasUI) {
        ctx.ui.notify(
          "PR creation output contains extra URLs. Attach the created PR with /prs add <url>.",
          "warning",
        );
      }
      return;
    }

    for (const line of output.split(/\r?\n/)) {
      const created = stripVTControlCharacters(line).match(
        /\bCreated PR #([1-9]\d*) for /,
      );
      if (!created) continue;

      const linkedUrl = line.match(/\x1b\]8;;([^\x1b\x07]+)(?:\x1b\\|\x07)/)?.[1];
      let pr = parseSessionPr(linkedUrl);
      if (!pr) {
        const args = ["pr", "view", created[1], "--json", "url", "--jq", ".url"];
        if (creation.repo) args.push("--repo", creation.repo);
        const result = await pi.exec("gh", args, {
          cwd: creation.cwd,
          timeout: 10_000,
          signal: ctx.signal,
        });
        if (result.code === 0) pr = parseSessionPr(result.stdout);
      }
      if (pr) {
        addSessionPr(pr, ctx);
      } else if (ctx.hasUI) {
        ctx.ui.notify(
          `Could not track PR #${created[1]}. Add its URL with /prs add <url>.`,
          "warning",
        );
      }
    }
  }

  async function recoverSessionPrs(ctx: ExtensionContext) {
    const entries = [...ctx.sessionManager.getEntries()];
    const commands = new Map<string, string>();
    for (const entry of entries) {
      if (entry.type !== "message" || entry.message.role !== "assistant") continue;
      for (const block of entry.message.content) {
        if (
          block.type === "toolCall" && block.name === "bash" &&
          typeof block.arguments.command === "string"
        ) {
          commands.set(block.id, block.arguments.command);
        }
      }
    }
    for (const entry of entries) {
      if (entry.type !== "message" || entry.message.role !== "toolResult") continue;
      const message = entry.message;
      if (message.toolName !== "bash" || processedCalls.has(message.toolCallId)) continue;
      const command = commands.get(message.toolCallId);
      if (!command) continue;
      const output = message.content
        .filter((block) => block.type === "text")
        .map((block) => block.text)
        .join("\n");
      await recordPrCreation(command, output, message.isError, ctx);
      processedCalls.add(message.toolCallId);
    }
  }

  pi.on("session_start", async (_event, ctx) => {
    prs.clear();
    processedCalls.clear();
    // PRs remain on GitHub when navigating to another conversation branch.
    for (const entry of ctx.sessionManager.getEntries()) {
      if (entry.type !== "custom" || entry.customType !== PR_ENTRY_TYPE) continue;
      const pr = parseSessionPr((entry.data as { url?: unknown } | null)?.url);
      if (pr) prs.set(pr.url, pr);
    }
    updatePrStatus(ctx);
    await recoverSessionPrs(ctx);
  });

  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "bash" || typeof event.input.command !== "string") return;
    const structured = event.structuredContent as { output?: unknown } | undefined;
    const output =
      typeof structured?.output === "string"
        ? structured.output
        : event.content
            .filter((block) => block.type === "text")
            .map((block) => block.text)
            .join("\n");
    await recordPrCreation(event.input.command, output, event.isError, ctx);
    processedCalls.add(event.toolCallId);
  });

  pi.registerCommand("prs", {
    description: "Open this session's PRs, or attach one with /prs add <url>",
    handler: async (args, ctx) => {
      const input = args.trim();
      if (input) {
        const match = input.match(/^add\s+(\S+)$/);
        const pr = match && parseSessionPr(match[1]);
        if (!pr) {
          ctx.ui.notify(
            "Usage: /prs or /prs add https://github.com/owner/repo/pull/123",
            "warning",
          );
          return;
        }
        const added = addSessionPr(pr, ctx);
        ctx.ui.notify(
          `${pr.repo}#${pr.number} ${added ? "added to" : "is already in"} this session.`,
          "info",
        );
        return;
      }

      await recoverSessionPrs(ctx);
      if (!ctx.hasUI) return;
      if (prs.size === 0) {
        ctx.ui.notify("No PRs recorded. Attach one with /prs add <url>.", "info");
        return;
      }

      const choices = new Map(
        [...prs.values()].map((pr) => [`${pr.repo}#${pr.number}`, pr]),
      );
      const selected = await ctx.ui.select("Session PRs", [...choices.keys()]);
      if (!selected) return;
      const pr = choices.get(selected)!;
      const result = await pi.exec("gh", ["pr", "view", pr.url, "--web"], {
        cwd: ctx.cwd,
        timeout: 10_000,
      });
      if (result.code !== 0) {
        ctx.ui.notify(`Could not open ${pr.url}: ${result.stderr.trim()}`, "error");
      }
    },
  });
}
