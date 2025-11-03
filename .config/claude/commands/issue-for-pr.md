Make an issue for an existing PR.

Use the `gh` CLI to get information about the pull request for the current git branch.

If the PR has mentions a related Linear issue, do nothing.

If the PR does not mention a related Linear issue, create one using the Linear MCP.

- Team: usually Platform, but customer-managed-related repositories indicate
  that the issue should be created in the Customer Managed team.
- Cycle: assign the currently-active cycle.
- Assignee: assign myself.
- Labels: infer labels from the the `type` and `repo` label groups.
- Infer labels, estimate, and priority from the pull request details and changes.

If you are unsure of any fo these details, ask for clarification.

Finally, provide a link to the Linear issue in the output. Also, update the PR
description to mention that it is related to this issue.
For example: `Related to https://https://linear.app/prefect/issue/ABC-123`
