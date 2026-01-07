Make an issue for an existing PR.

Use the `gh` CLI to get information about the pull request for the current git branch.

If the PR already mentions a related Linear issue, do nothing.

If the PR does not mention a related Linear issue, create one via the Linear MCP.

The description should describe the need that the pull request addresses.
For example: if the pull request fixes a bug, the pull request should have
phrasing similar to: "Line 123 has a bug with error message ABC that results
in DEF".

Use the following indicators to apply metadata to the issue:

- Team: usually Platform, but customer-managed-related repositories indicate
  that the issue should be created in the Customer Managed team.
- Cycle: assign the currently-active cycle.
- Assignee: assign myself.
- Labels: infer labels from the `type` and `repo` label groups.
- Infer labels, estimate, and priority from the pull request details and changes.

If you are unsure of any of these details, ask for clarification.

Finally, provide a link to the Linear issue in the output and update the PR
description to mention that it is related to this issue.

For example: `Related to https://https://linear.app/prefect/issue/ABC-123`
