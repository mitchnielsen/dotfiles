---
description: Commit changes, push the branch, and create a pull request
argument-hint: "[commit and PR context]"
---

# Ship

Additional context from me to include in the commit message and pull request:
$ARGUMENTS

Complete the workflows defined in these command files, in order:

1. `~/.config/agents/commands/commit.md`
2. `~/.config/agents/commands/push.md`
3. `~/.config/agents/commands/pr.md`

Before each step, read its command file and gather its git context at that
time. Follow its instructions as if it had been invoked directly. Use the
additional context above for both the commit and pull request.

Do not start a later step if an earlier step fails or requires clarification.
