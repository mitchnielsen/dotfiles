---
name: review-pr
description: Review a pull request and suggest comments
---

Review the given pull request: $ARGUMENTS.

Use the `gh` CLI to view the pull request details.

Consider:
- Why the pull request was created
- What the pull request does
- Potential typos or misconfiguration
- Potential semantic issues
- What future impact this pull request might have on maintainability and usability

Finally,
- Write a quick summary of your thoughts on the pull request for me.
- Include your recommendation: merge as-is, request edits, or close.
- When applicable, include a suggested comment for me to post to the author.
