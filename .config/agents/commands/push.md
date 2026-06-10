---
description: Push changes to the git remote
---

# Push

## Git Context

Current branch:
!`git branch --show-current`

Status:
!`git status -sb`

Upstream:
!`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || true`

Existing pull request, if any:
!`gh pr view --json url,title,state --jq '"\(.state) \(.title) \(.url)"' 2>/dev/null || true`

Unpushed commit subjects, if an upstream exists:
!`git log --pretty=format:%s @{u}..HEAD 2>/dev/null || true`

## Instructions

Push the current branch. If an upstream is already configured, use `git push`.
Otherwise, use `git push -u origin <branch>`.

If there are changes on the target branch that are not present locally,
run `git pull --rebase`.

If there is an associated pull request, only fetch and update the PR
description when the unpushed commits clearly make it stale. Otherwise,
leave the PR unchanged.
