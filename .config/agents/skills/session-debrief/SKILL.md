---
name: session-debrief
description: Reviews the current agent session when the user asks for a debrief, asks what to improve next time, or invokes /skill:session-debrief. Finds repeatable friction such as failed tool calls, missing CLIs, and inefficient workflows, then makes verified improvements to personal dotfiles, agent configuration, AGENTS.md, or existing skills. Use at the end of a session, not for code review.
---

# Session debrief

Review the session you are in. Use the conversation and tool results you can actually access. If earlier details were compacted away, say what you cannot verify instead of reconstructing them. Do not search other sessions unless the user asks.

1. Find concrete friction: failed or malformed tool calls, unavailable commands, repeated retries, avoidable tool calls, and user corrections. Note the original attempt, its result, and any successful replacement. Ignore one-off slips that do not suggest a reusable fix.
2. Check each candidate against the current tools, CLI help, and relevant files before changing anything. Distinguish a missing command from a PATH problem or a wrong command name. Confirm that a faster approach works and preserves the intended result.
3. Choose the smallest durable home for each fix. Put a recurring way of working in the relevant skill. Put shared behavioral rules in AGENTS.md only when they are genuinely general. Put deterministic setup in the appropriate config or script. Avoid duplicating instructions or recording session anecdotes as rules.
4. Apply small, verified changes in the user's dotfiles or agent configuration. Preserve unrelated edits. Do not install software, change security settings, or edit project files outside the user's personal config without approval. If a fix is uncertain or broad, propose it instead. Never copy secrets, tokens, or private transcript content into persistent files.
5. Run the relevant check for each change and inspect the resulting diff. Report what changed, the session evidence for it, and what you verified. List worthwhile fixes left for approval. If nothing clears the bar, say so without making a token edit.

Keep the debrief short. Prefer one proven improvement over a list of speculative rules.
