# Commit our changes in version control

## Prerequisites

Make sure that we are on a feature branch and not on the default branch.
If not, stop and ask for clarification.

Make sure all current files are committed. If `pre-commit` hooks
fail, just re-add the files that failed and commit them again.

- NEVER `amend` a commit under any circumstances. Ask for my help instead.
- NEVER USE `git commit --no-verify` under any circumstance. Ask for my help
instead.
- DO NOT push until explicitly told to push.

## Commit format

Write a commit with the following guidelines.

### What to include

- Additional context from me to include in the commit message: $ARGUMENTS
- Follow the Conventional Commits format for commit tiles. Examples:
  - docs: correct spelling of CHANGELOG
  - feat(api): send an email to the customer when a product is shipped
- Be conversational and humble: avoid "comprehensive" or confident
  "root cause" claims, it highlights your Dunning-Kruger issues
- Be brief: focus on what/why not how
- Include contextual links (logs, issues, PRs) that would help a
  reviewer get context
- Always mention related issues when available:
  "Closes #1234" or "Closes ENG-1234"

Finally, include a brief summary of the development session that produced the
changes. Focus on context a reviewer wouldn't get from reading the code: what
kicked off the work, key decisions or trade-offs, alternatives rejected, and
anything surprising discovered along the way.

- **Commit messages**: Include session context in the commit body (after the
  subject line), 2-3 lines max
- **PR descriptions**: Include session context in a collapsible `<details>` block
  at the end of the body

This applies regardless of how the commit/PR is created — explicit commands,
ad-hoc requests, or any other workflow.

### What not to include

- No checklists or file lists (but change lists OK)
- No "test plan" checklist
