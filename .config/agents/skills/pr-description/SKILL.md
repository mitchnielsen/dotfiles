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
  - Use "Closes" instead of "Related to" if the PR fully addresses
    the issue.
- Include contextual links (logs, issues, PRs, materials) that help
  a reviewer get oriented.
- Include session context in a collapsible `<details>` block at the
  end of the body.

### Style

- Be conversational and humble. Avoid "comprehensive" or confident
  "root cause" claims.
- Brief. Focus on what/why, not how.
- No checklists or file lists, but respect existing checklist items
  if a PR template defines them.
- No "Test Plan" checklist.

## Output

After creating or updating a PR, always provide the title and a clickable link.

Example: https://github.com/PrefectHQ/platform/pull/123
