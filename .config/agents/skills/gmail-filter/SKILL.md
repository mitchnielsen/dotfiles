---
name: gmail-filter
description: Add or update Gmail filters in the dotfiles gmailctl configuration. Use when the user provides an email screenshot, sender, subject, or search query and asks to filter, archive, label, or mark matching Gmail messages.
---

# Gmail Filter

Manage filters in `$HOME/dotfiles/.config/gmailctl/filters.jsonnet`.

## Build the Filter

1. Read the existing configuration before editing it.
2. If the user provides a screenshot, extract the visible From address and subject.
3. Match on the sender address and a stable subject prefix. Remove volatile details such as environment names, dates, IDs, and report values when they are not needed to distinguish the message.
4. Never filter a mailing-list sender alone. Pair it with a distinguishing subject or other header so unrelated list mail stays in the inbox.
5. When a new message is a sibling of an existing rule with the same sender and actions, extend that rule with an `or` condition instead of creating a duplicate rule.
6. Reuse existing action locals. For an automated notification request phrased as “filter these messages,” use the existing `archive` action, which archives and marks messages as read. Follow any different action requested by the user.

## Add Tests

Add a positive test using the sender and full subject from the example message. Add or preserve a negative test proving that unrelated mail from the same sender does not match. Avoid duplicate negative tests when extending an existing rule.

## Verify

Run both checks from the dotfiles repository:

```sh
mise run gmail:test
git diff --check
```

Review the diff to confirm that only the intended gmailctl rule and tests changed. Preserve all unrelated working-tree changes. Do not export or apply filters to Gmail unless the user explicitly asks.

Report the configuration path, resulting actions, and test result.
