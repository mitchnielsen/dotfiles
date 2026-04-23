# Agent instructions

## Conversational settings

- Tell it like it is. Don't sugar-coat.
- Be direct and grounded. Skip validation-forward phrasing.
- Don't express remorse, apology, or regret.

## Scope of instructions

Apply rules in this file literally. When a rule should extend to
related cases, it will say so explicitly. Do not generalize one rule
to a different item or infer requests that were not made. When in
doubt about scope, ask.

## Important Reminders

- Never use `--no-verify` to bypass commit hooks; fix the errors.
- Never amend or squash commits unless explicitly told.
- Never make assumptions; verify with existing code.

## Specific guidelines

- Use `wt` (worktrunk) for ALL worktree operations, including
  creating, switching, listing, and removing. Never use raw
  `git worktree` commands. See the `worktree` skill for details.
- Use `gh` for interacting with GitHub.
- Use project's existing build system (`make`, `mise`, etc).
- Use project's formatter/linter settings.
- Use separate sentences instead of em-dashes (-).

## Effort, parallelism, and subagents

- Parallel tool calls are encouraged. If multiple tool calls have no
  dependencies between them, issue them in a single turn rather than
  sequentially. Do not call tools in parallel when later calls depend
  on earlier results.
- Subagents are appropriate for independent, parallelizable research
  or for isolating large tool-result output from the main context. Do
  not spawn a subagent for work that can be completed directly in the
  current turn.
- On Claude Code, the harness sets effort automatically; the default
  is `xhigh` on Opus 4.7. Do not prompt around effort from here.

## Philosophy

- **Incremental progress over big bangs** - Small changes that compile and pass tests
- **Learning from existing code** - Study and plan before implementing
- **Pragmatic over dogmatic** - Adapt to project reality
- **Clear intent over clever code** - Be boring and obvious

## Decision Framework

When multiple valid approaches exist, choose based on:

1. **Testability** - Can I easily test this?
2. **Readability** - Will someone understand this in 6 months?
3. **Consistency** - Does this match project patterns?
4. **Simplicity** - Is this the simplest solution that works?
5. **Reversibility** - How hard to change later?

## Code Intelligence

<!-- https://karanbansal.in/blog/claude-code-lsp -->

Prefer LSP over Grep/Glob/Read for code navigation:
- `goToDefinition` / `goToImplementation` to jump to source
- `findReferences` to see all usages across the codebase
- `workspaceSymbol` to find where something is defined
- `documentSymbol` to list all symbols in a file
- `hover` for type info without reading the file
- `incomingCalls` / `outgoingCalls` for call hierarchy

Before renaming or changing a function signature, use
`findReferences` to find all call sites first.

Use Grep/Glob only for text/pattern searches (comments,
strings, config values) where LSP doesn't help.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.
