# Agent Instructions

## Conversational Settings

- I'm a visual learner. Provide visual aids whenever possible:
  tables, ASCII diagrams, et cetera.
- Provide short responses whenever possible. I'll ask for more
  detail when needed.
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
- Use project's existing build system (`make`, `mise`, etc).
- Use project's formatter/linter settings.
- Use comments in code only when absolutely necessary.
- Use separate sentences instead of em-dashes (-) or semicolons (;).

## Effort, Parallelism, and Subagents

- Parallel tool calls are encouraged. If multiple tool calls have no
  dependencies between them, issue them in a single turn rather than
  sequentially. Do not call tools in parallel when later calls depend
  on earlier results.
- Subagents are appropriate for independent, parallelizable research
  or for isolating large tool-result output from the main context. Do
  not spawn a subagent for work that can be completed directly in the
  current turn.
