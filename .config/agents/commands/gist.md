---
description: Push the most recent assistant response into a GitHub gist
---

Take the most recent assistant message in this conversation (the one
immediately preceding this `/gist` invocation, not this current
response) and publish it as a GitHub gist using `gh`.

## Steps

1. **Ask visibility.** Use `AskUserQuestion` with a single question
   ("Public or secret gist?") and two options: `Public` and
   `Secret`. Do not assume a default. Wait for the answer before
   continuing.

2. **Auto-generate metadata** from the content of the message:
   - **Filename**: a short kebab-case slug derived from the message's
     topic, ending in `.md` (e.g. `kafka-consumer-lag-notes.md`).
     Keep under 60 chars. ASCII only.
   - **Description**: a single sentence (under 100 chars) summarizing
     what the gist contains. No trailing period.
   - Do not ask me to confirm these. Just pick reasonable values.

3. **Write the message body to a temp file**, preserving the original
   Markdown exactly as it appeared (including code fences, lists,
   tables). Do not add a title, preamble, or footer. Use
   `mktemp -t gist.XXXXXX.md` to get a path ending in `.md` so the
   gist renders as Markdown, then write the assistant message
   verbatim with the `Write` tool.

4. **Create the gist** with `gh`:
   ```
   gh gist create <tempfile> \
     --filename <generated-filename> \
     --desc "<generated-description>" \
     [--public]
   ```
   Include `--public` only if I chose Public in step 1. Omit it for
   Secret (that is `gh`'s default).

5. **Capture the URL** from stdout. `gh gist create` prints the gist
   URL on its last line.

6. **Copy the URL to the clipboard** with `printf '%s' "<url>" | pbcopy`.
   Use `printf` not `echo` to avoid a trailing newline in the clipboard.

7. **Report back** with a one-line summary in this shape:

   ```
   <visibility> gist created: <url> (copied to clipboard)
   filename: <generated-filename>
   ```

## Rules

- Never include any of *my* prompts, system reminders, tool calls, or
  tool results in the gist. Only the assistant message body.
- If the most recent assistant message is itself this `/gist`
  invocation's response (i.e. there is nothing prior to gist), stop
  and tell me — do not invent content.
- Do not commit anything, do not touch the working tree, do not push
  to git. This command only talks to the GitHub gist API via `gh`.
- Do not open the gist in the browser. Just print the URL.
