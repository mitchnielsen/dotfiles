Create a PR based on our current branch using the `gh` command-line tool.

Additional context from me to include in the PR and commit messages: $ARGUMENTS

First, make sure that we are on a branch besides `main`. If we are on
`main`.

Second, make sure all of the current files are committed. If `pre-commit` hooks
fail, just re-add the files that failed and commit them again.

NEVER EVER `amend` a commit under any circumstances. Ask for my help instead.
NEVER USE `git commit --no-verify` under any circumstance. Ask for my help
instead.

Then, finally use `gh pr create` to create the PR. If there is only a single
commit, use the commit message as the PR message. If there are multiple commits,
synthesize a new one that covers all of those changes.

## Commit/PR descriptions

- IMPORTANT: THIS STYLE GUIDE IS REQUIRED AND MANDATORY
- Be conversational and humble, avoid "comprehensive" or confident
  "root cause" claims, it highlights your Dunning-Kruger issues
- Brief, focus on what/why not how
- No checklists or file lists (but change lists OK)
- No "Test Plan" checklist
- Always mention related issues when available
  - Based on our conversation, use "Closes #1234" or "Closes ENG-1234"
- Include contextual links (logs, issues, PRs, materials) that would help a
  reviewer get oriented on what we're talking about
