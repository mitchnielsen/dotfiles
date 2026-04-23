---
description: Review a pull request and suggest comments
---

Review the given pull request: $ARGUMENTS.

Use the `gh` CLI to view the PR details, diff, and any existing
review comments.

## Stage 1: find everything

Your job in this stage is coverage, not filtering. Report every
issue you find, including ones you are uncertain about or consider
low-severity. Do not silently drop findings because they seem minor
or speculative. A separate filtering step will handle triage.

For each finding, record:

- **Location**: file and line
- **Finding**: what is wrong or questionable
- **Confidence**: low / medium / high
- **Severity**: low / medium / high
- **Category**: one of: bug, typo, misconfiguration, semantic issue,
  maintainability, usability, style

Look for:

- Bugs that could cause incorrect behavior, a test failure, or a
  misleading result
- Typos and misconfiguration
- Semantic issues and logic errors
- Future impact on maintainability and usability
- Missing tests for changed behavior

## Stage 2: triage and recommend

After the findings list is complete, filter it:

- Keep anything with severity medium or high, regardless of
  confidence.
- Keep low-severity findings only if confidence is high.
- Drop nits that are pure style or naming preference unless they
  affect readability materially.

Then produce:

1. A short summary of what the PR does and why.
2. The filtered findings list.
3. A recommendation: merge as-is, request edits, or close.
4. If edits are warranted, a suggested comment to post to the
   author. Copy the suggested comment to the clipboard via `pbcopy`.
