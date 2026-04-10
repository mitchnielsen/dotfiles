---
name: linear-issue
description: "Conventions for creating Linear issues: team defaults, label inference, priority, and metadata"
user-invocable: false
---

# Linear Issue Conventions

Use this skill when creating or updating Linear issues via the
Linear MCP server.

## Team Defaults

- Default team: **Platform** (ID: `0cf54a8c-b85d-4637-b6fd-89670b625782`)
- Customer-managed-related repositories should use the **Customer Managed**
  team (ID: `6154c1ee-2d52-4d3b-a5cd-395789c8696e`)

If the user does not specify a team, use Platform.

## Status

If the user does not specify a status, use **Backlog**.

## Labels

Make a best effort guess to choose labels. If the team is Platform,
apply a label from each of the **type** and **repo** label groups.

## Priority

Make a best effort guess at priority. If unsure, **Medium** is a
safe default.

## Issue Descriptions

Describe the need, not the solution. For bug fixes, use phrasing
like: "Line 123 has a bug with error message ABC that results in DEF".

## Linking Issues

When linking a Linear issue to a GitHub PR, use this format in the
PR description:

```
Related to https://linear.app/prefect/issue/ABC-123
```

Use "Closes" instead of "Related to" if the PR fully addresses the
issue.

## Output

After creating an issue, always provide the title and a clickable
link to the issue in Linear.
