---
description: Debug a CI failure
---

CI run reference: $ARGUMENTS

Use the `gh` CLI to look at the logs for the CI run provided
as the argument to this command.

If no argument is provided, use the `gh` CLI to see the latest workflow
runs for the current branch.

Start with `gh run view <run-id> --log-failed`. Read the full log only
when the failed steps don't explain the failure.
Report your findings and suggest possible solutions.
