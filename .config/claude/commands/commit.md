Commit our changes in version control.

Additional context from me to include in the commit message: $ARGUMENTS

First, make sure that we are on a feature branch and not on the default branch.
If not, stop and ask for clarification.

Second, make sure all of the current files are committed. If `pre-commit` hooks
fail, just re-add the files that failed and commit them again.

NEVER EVER `amend` a commit under any circumstances. Ask for my help instead.
NEVER USE `git commit --no-verify` under any circumstance. Ask for my help
instead.

Make sure all of the current files are committed. If `pre-commit` hooks
fail, just re-add the files that failed and commit them again.

NEVER EVER `amend` a commit under any circumstances. Ask for my help instead.
NEVER USE `git commit --no-verify` under any circumstance. Ask for my help
instead.

DO NOT push until explicitly told to push.

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
