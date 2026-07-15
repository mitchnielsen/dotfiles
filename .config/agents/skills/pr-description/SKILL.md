---
name: pr-description
description: "Conventions for writing pull request titles and descriptions: Conventional Commits title, issue linking, style guide"
user-invocable: false
---

# Pull Request Title and Description Conventions

Use this skill when creating or updating pull request titles and
descriptions.

## Title

Follow the Conventional Commits format, same as commit messages
(see the `commit-message` skill). If a title was auto-generated
from a commit that does not follow the format, rewrite it.

## Description

### Content

- Always mention related issues when available.
  - GitHub issue: "Related to #1234"
  - Linear issue: "Related to ENG-1234"
  - Never use "Closes". I'll decide when to close the related issue.
- Include contextual links (logs, issues, PRs, etc) that help a reviewer get oriented.
- Include an ASCII diagram when relevant. A picture is worth a thousand words.
- Include session context in a collapsible `<details>` block at the
  end of the body.

### Style

- Be conversational and humble. Avoid "comprehensive" or confident
  "root cause" claims.
- Be brief. Focus on what/why, not how. Additional commits to the
  pull request may change the approach, so keep the description focused
  enough to not require major rewrites in most cases.
- No checklists or file lists, but respect existing checklist items
  if a PR template defines them.
- No "Test Plan" checklist.

## Output

After creating or updating a PR, always provide the title and a clickable link.

Example: https://github.com/PrefectHQ/platform/pull/123
