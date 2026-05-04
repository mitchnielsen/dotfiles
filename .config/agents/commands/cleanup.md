---
description: Clean up local work
---

Work has finished, meaning the related pull request has merged or
been closed.

## Identify the worktree

Use the `worktree` skill. The target is the worktree for the branch
whose PR has just closed.

- If the current branch is not `main`, the session is running from
  the feature branch itself. The target is the current worktree.
- If the current branch is `main`, the session is running from the
  `main` directory and one or more worktrees were used. Run `wt
  list` and identify the worktree for this work. If more than one
  candidate exists, ask which to clean up rather than guessing.

## Verify the PR is actually closed

Before removing anything, confirm with `gh pr view <branch> --json
state,merged` that the PR is `MERGED` or `CLOSED`. If it is still
open, stop and report. Do not remove worktrees for open PRs.

## Remove

`wt remove` is safe by default: it refuses to remove a worktree
with untracked files and only deletes the branch if it is merged
(or empty relative to `main`). Lean on those defaults instead of
adding flags.

- From the feature branch: print `wt remove` and copy it to the
  clipboard with `pbcopy`. Do not run it yourself; the session is
  inside the worktree being removed.
- From `main`: run `wt remove <branch>` directly.

If `wt remove` reports untracked files or an unmerged branch, stop
and report what it found. Do not reach for `--force` or
`--force-delete` without my say-so.
