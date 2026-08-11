---
description: Start work on a new feature branch for a Linear or GitHub issue
---

Issue: $ARGUMENTS

## Identify the issue

Parse the argument as follows:

- If it matches `ABC-123`, treat it as a Linear issue ID and look it
  up via the `linear` MCP tools.
- If it matches `#123`, treat it as a GitHub issue ID and look it up
  via the `gh` CLI.
- Otherwise, treat the argument as a free-text description of an
  idea to try. There is no issue tracker entry in this case.

Read the issue description and follow any links or references in it
to understand the full scope.

## Align and pitch

This is a long-horizon agentic task. Do not create a worktree or write
code until the pitch is approved.

1. Enter planning mode if the current harness supports it.
2. Resolve material requirements before proposing an implementation.
   Ask one question at a time rather than filling gaps with assumptions.
3. Inspect the current code paths and existing tests.
4. Use the `pitch` skill to present the concrete call flow, contracts,
   affected files, and scope.
5. Include the testing approach in the pitch. Name the tests to add or
   update and the commands that will validate the change.
6. Prioritize testing. If the repository has a runnable test suite,
   write tests first and use them to drive implementation.
7. If the repository has no test suite or its tests are not runnable
   locally, state that explicitly in the pitch. This is acceptable.
8. If any part of the requirements or testing approach is unclear, ask
   before pitching.

Present the pitch and wait for my approval.

## Set up the worktree

Use the `worktree` skill. Create a new worktree with `wt switch
--create <branch>`. Do not use raw `git worktree` commands and do
not invent a directory layout; `wt` handles that.

Branch names must not contain slashes. Use dashes instead.

## Implement

After I approve the pitch, implement it autonomously and unattended.

- Implement the approved pitch exactly.
- If tests exist, do not declare victory until they pass.
- Do not stop at partial implementations.
- If implementation requires any deviation from the pitch, stop and
  report what changed and why before continuing.
