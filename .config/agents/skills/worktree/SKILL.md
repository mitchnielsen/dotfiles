---
name: worktree
description: "Guide for using `wt` (worktrunk) to manage git worktrees for parallel work on multiple feature branches"
user-invocable: false
---

# Git Worktrees with `wt`

Use this skill when managing parallel feature branches. The `wt`
binary (worktrunk) manages git worktrees so multiple branches can be
checked out simultaneously in separate directories.

Always use `wt` instead of raw `git worktree` commands.

## Core Concepts

A worktree is a separate working directory linked to the same
repository. Each worktree has its own branch checked out. This allows
parallel development without stashing or switching branches.

Worktrees are addressed by branch name. Paths are computed
automatically from a configurable template.

## Common Workflows

### Start a new feature branch

```bash
wt switch --create my-feature
```

This creates a new branch from the default branch and sets up a
worktree. To branch from a specific base:

```bash
wt switch --create hotfix --base production
```

### Switch between worktrees

```bash
wt switch my-feature    # switch to existing worktree
wt switch -             # switch to previous worktree (like cd -)
wt switch ^             # switch to default branch worktree
wt switch pr:123        # switch to a GitHub PR's branch
```

Without arguments, `wt switch` opens an interactive picker.

### See all worktrees

```bash
wt list                 # basic table
wt list --full          # include CI status, diffs, summaries
wt list --format=json   # structured output for scripting
```

### Committing and merging

Do not use `wt merge` or `wt step commit`/`squash`/`rebase`. Commit
with the `commit-message` skill. PRs merge on GitHub.

### Remove a worktree

```bash
wt remove               # remove current worktree
wt remove my-feature    # remove specific worktree
wt remove -D my-feature # force-delete unmerged branch
```

By default, `wt remove` deletes the branch if its changes are
already integrated into the default branch. Use `--no-delete-branch`
to keep it.

## Branch Naming

Branch names should NOT contain slashes (`/`). Use dashes (`-`)
instead. Slashes cause confusion with subdirectories in worktree paths.

## Shortcuts

| Shortcut  | Meaning                        |
|-----------|--------------------------------|
| `^`       | Default branch (main/master)   |
| `@`       | Current branch/worktree        |
| `-`       | Previous worktree (like cd -)  |
| `pr:{N}`  | GitHub PR #N's branch          |

## Launching agents in worktrees

Use `--execute` to launch an editor or agent after switching:

```bash
wt switch --create my-feature --execute claude
wt switch --create fix --execute 'claude "Fix GH #322"'
```

Arguments after `--` are passed to the execute command:

```bash
wt switch --create fix --execute claude -- 'Fix GH #322'
```

## Integration with branch cleanup

`wt list` dims rows that are safe to delete (branch content is
integrated into the default branch). `wt remove` automatically
detects integrated branches using multiple strategies: same commit,
ancestor check, tree comparison, simulated merge, and patch-id
matching. This works with squash-merge and rebase workflows.

## Pruning stale worktrees

```bash
wt step prune           # remove worktrees merged into default branch
```
