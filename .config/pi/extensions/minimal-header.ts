/**
 * Minimal Header Extension
 *
 * Replaces the default startup header (skills, extensions, keyboard shortcuts)
 * with a clean, minimal one.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (ctx.hasUI) {
			ctx.ui.setHeader((_tui, theme) => ({
				render(): string[] {
					return [theme.fg("accent", "π")];
				},
				invalidate() {},
			}));
		}
	});
}
