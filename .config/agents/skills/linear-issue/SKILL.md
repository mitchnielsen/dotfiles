---
name: linear-issue
description: "Conventions for creating Linear issues: team defaults, label inference, priority, and metadata"
user-invocable: false
---

# Linear Issue Conventions

Use this skill when creating or updating Linear issues via the
Linear MCP server.

## Team Defaults

- Default team: **Horizon** (identifier: `HRZN`)
- Customer-managed-related repositories should use the **Customer Managed**
  team (identifier: `CUS`)
- Platform-related repositories (`platform`, `cloud2-helm`,
  `terraform-provider-prefect`, `cluster-deployment`,
  `prometheus-prefect-exporter`, etc.) should use the **Platform** team
  (identifier: `PLA`)

If the user does not specify a team and you're not sure which one to use, ask.

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

After creating an issue, always provide the title and a bare,
unwrapped URL to the issue in Linear. Do not put the URL inside
markdown link syntax (`[title](url)`) — paste the raw URL so the
user can click or copy it directly from the terminal.

Example:

```
Created PLA-1234: Some issue title
https://linear.app/prefect/issue/PLA-1234/some-issue-title
```
