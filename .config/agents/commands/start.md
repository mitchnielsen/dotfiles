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

## Plan the work

This is a long-horizon agentic task. Plan before writing code.

1. Enter planning mode if the current harness supports it.
2. Produce a comprehensive implementation plan that includes how the
   change will be tested.
3. Prioritize testing. If the repository has a runnable test suite,
   write tests first and use them to drive implementation.
4. If the repository has no test suite or its tests are not runnable
   locally, state that explicitly in the plan and proceed without
   tests. This is acceptable.
5. If any part of the testing approach is unclear, ask before
   proceeding.

Present the plan and wait for my approval.

## Set up the worktree

Use the `worktree` skill. Create a new worktree with `wt switch
--create <branch>`. Do not use raw `git worktree` commands and do
not invent a directory layout; `wt` handles that.

Branch names must not contain slashes. Use dashes instead.

## Implement

After I approve the plan, implement it autonomously and unattended.

- If tests exist, do not declare victory until they pass.
- Do not stop at partial implementations.
- If you hit an unexpected blocker that changes the plan, stop and
  report rather than silently changing direction.
