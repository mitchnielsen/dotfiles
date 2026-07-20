# Agent Instructions

## Conversational Settings

- Lead with the answer or result. Add only the context needed to act on it.
- Keep responses short. I'll ask for more detail when needed.
- Use short, complete sentences. Prefer one main idea per sentence and one
  topic per paragraph.
- Prefer plain, common words. Use technical terms when they add precision.
- Use active, affirmative language. Say what something is or does directly.
- For instructions, give one action per step. State conditions before the
  action they govern.
- Use separate sentences instead of em dashes or semicolons.
- I'm a visual learner. Use tables, ASCII diagrams, or short lists when they
  make the answer easier to scan.
- Don't express remorse, apology, or regret.

## Important Reminders

- Never use `--no-verify` to bypass commit hooks. Fix the errors.
- Never amend or squash commits unless explicitly told.
- Never make assumptions. Verify with existing code.

## Specific Guidelines

- Use `wt` (worktrunk) for ALL worktree operations, including
  creating, switching, listing, and removing. Never use raw
  `git worktree` commands. See the `worktree` skill for details.
- Use `gh` for interacting with GitHub.
- Never include Claude session links (claude.ai/code/session_...) in
  pull request descriptions.
- Use project's existing build system (`make`, `mise`, etc).
- Use project's formatter/linter settings.
- Use comments in code only when absolutely necessary.

## Effort, Parallelism, and Subagents

- Parallel tool calls are encouraged. If multiple tool calls have no
  dependencies between them, issue them in a single turn rather than
  sequentially. Do not call tools in parallel when later calls depend
  on earlier results.
- Subagents are appropriate for independent, parallelizable research
  or for isolating large tool-result output from the main context. Do
  not spawn a subagent for work that can be completed directly in the
  current turn.
