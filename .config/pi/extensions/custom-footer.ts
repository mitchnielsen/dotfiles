import { homedir } from "node:os";
import { isAbsolute, relative, sep } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function formatTokens(count: number): string {
  if (count < 1_000) return count.toString();
  if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
  if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
  if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
  return `${Math.round(count / 1_000_000)}M`;
}

function formatCwd(cwd: string): string {
  const home = homedir();
  const relativeToHome = relative(home, cwd);
  const isInHome =
    relativeToHome === "" ||
    (relativeToHome !== ".." &&
      !relativeToHome.startsWith(`..${sep}`) &&
      !isAbsolute(relativeToHome));

  if (!isInHome) return cwd;
  return relativeToHome === "" ? "~" : `~${sep}${relativeToHome}`;
}

function alignSides(left: string, right: string, width: number): string {
  const rightWidth = visibleWidth(right);
  const maxLeftWidth = width - rightWidth - 2;
  if (maxLeftWidth <= 0) return truncateToWidth(right, width, "");

  const fittedLeft = truncateToWidth(left, maxLeftWidth, "…");
  const padding = " ".repeat(
    width - visibleWidth(fittedLeft) - rightWidth,
  );
  return fittedLeft + padding + right;
}

interface FooterState {
  dirty?: boolean;
  requestRender?: () => void;
}

async function refreshDirtyState(
  pi: ExtensionAPI,
  ctx: ExtensionContext,
  state: FooterState,
): Promise<void> {
  const result = await pi.exec(
    "git",
    ["status", "--porcelain", "--untracked-files=normal"],
    { cwd: ctx.cwd, timeout: 5_000 },
  );
  state.dirty = result.code === 0 ? result.stdout.length > 0 : undefined;
  state.requestRender?.();
}

function setCustomFooter(
  pi: ExtensionAPI,
  ctx: ExtensionContext,
  state: FooterState,
): void {
  ctx.ui.setFooter((tui, theme, footerData) => {
    const requestRender = () => tui.requestRender();
    state.requestRender = requestRender;

    return {
      dispose() {
        if (state.requestRender === requestRender) {
          state.requestRender = undefined;
        }
      },
      invalidate() {},
      render(width: number): string[] {
        const stats: string[] = [];
        if (state.dirty) {
          stats.push(theme.fg("warning", "dirty"));
        }

        const contextUsage = ctx.getContextUsage();
        const contextWindow =
          contextUsage?.contextWindow ?? ctx.model?.contextWindow;
        if (contextWindow) {
          const percent = contextUsage?.percent;
          const context =
            percent === null || percent === undefined
              ? `context ? of ${formatTokens(contextWindow)}`
              : `context ${percent.toFixed(1)}% of ${formatTokens(contextWindow)}`;
          const color =
            percent !== null && percent !== undefined && percent > 90
              ? "error"
              : percent !== null && percent !== undefined && percent > 70
                ? "warning"
                : "dim";
          stats.push(theme.fg(color, context));
        }

        const modelName = ctx.model?.id ?? "no model";
        const modelLabel = ctx.model?.reasoning
          ? `${modelName} · thinking ${pi.getThinkingLevel()}`
          : modelName;
        const model = theme.fg("dim", modelLabel);
        const separator = theme.fg("dim", " · ");
        const statsLine = alignSides(stats.join(separator), model, width);

        const sessionName = pi.getSessionName();
        const location = sessionName
          ? `${formatCwd(ctx.cwd)} · ${sessionName}`
          : formatCwd(ctx.cwd);
        const lines = [
          truncateToWidth(
            theme.fg("dim", location),
            width,
            theme.fg("dim", "…"),
          ),
          statsLine,
        ];

        const statuses = [...footerData.getExtensionStatuses().values()]
          .map((status) => status.replace(/[\r\n\t]/g, " ").trim())
          .filter(Boolean)
          .join(" ");
        if (statuses) {
          lines.push(truncateToWidth(statuses, width, "…"));
        }

        return lines;
      },
    };
  });
}

export default function (pi: ExtensionAPI) {
  let enabled = true;
  const state: FooterState = {};

  pi.on("session_start", async (_event, ctx) => {
    if (!enabled || ctx.mode !== "tui") return;
    setCustomFooter(pi, ctx, state);
    await refreshDirtyState(pi, ctx, state);
  });

  pi.on("agent_settled", async (_event, ctx) => {
    if (enabled && ctx.mode === "tui") {
      await refreshDirtyState(pi, ctx, state);
    }
  });

  pi.registerCommand("footer", {
    description: "Toggle custom footer",
    handler: async (_args, ctx) => {
      enabled = !enabled;
      if (enabled) {
        if (ctx.mode === "tui") {
          setCustomFooter(pi, ctx, state);
          await refreshDirtyState(pi, ctx, state);
        }
        ctx.ui.notify("Custom footer enabled", "info");
      } else {
        ctx.ui.setFooter(undefined);
        ctx.ui.notify("Default footer restored", "info");
      }
    },
  });
}
