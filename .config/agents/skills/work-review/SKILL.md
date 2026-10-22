---
name: work-review
description: Review my GitHub and Linear work over a time period and write a single Markdown report of major projects and contribution patterns. Use when I ask to review my work, prep for a performance review or self-assessment, find work I'm proud of, or summarize what I did over the last N months.
---

# Work review

Find the major projects and recurring contribution patterns in my work over a period. Write the result to one Markdown file I can save in Obsidian.

## Inputs

- **Period.** Required. Accept a range ("2025-10-21 to 2026-10-21") or a duration ("last 12 months", "Q3"). Resolve it to absolute start and end dates. Ask if I didn't give one.
- **GitHub org.** Default `PrefectHQ`.
- **Output path.** Default `./work-review-<start>-to-<end>.md` in the current directory. Use the path I give instead.

## Step 1: Collect GitHub PRs

1. Get my login with `gh api user --jq .login`.
2. Count PRs per repo:
   `gh search prs --owner <org> --author @me --created "<start>..<end>" --limit 1000 --json repository --jq 'group_by(.repository.nameWithOwner) | map({repo: .[0].repository.nameWithOwner, n: length}) | sort_by(-.n)'`
3. Search returns at most 1000 results per query. Dump titles per repo, not in one org-wide query. Take the repo names from step 2 with `jq -r` and loop over them in a single Bash call. Write one TSV to the scratchpad:
   `gh search prs --repo <org>/<repo> --author @me --created "<start>..<end>" --limit 1000 --json number,title,state,createdAt,url`
4. Use absolute paths. The shell resets `cd` between calls.
5. Drop closed-unmerged PRs and dependency bumps. Match `bump`, `chore(deps)`, `renovate`, `update dependenc`, and `dependency-version-` (grouped Dependabot branches).
6. Read the remaining titles grouped by repo and sorted by date. Read them all, because skimming misses patterns. For about 1000 titles, split the read into 2–3 parallel calls by repo group.

## Step 2: Collect Linear context

Load the Linear tools with ToolSearch first.

1. Projects: `list_projects` with `member: "me"`, `updatedAt: <start>`, fields `name, summary, status, lead, startedAt, completedAt, url`. Note which ones I lead and which completed in the period.
   - `updatedAt` also returns projects that only changed recently. For example, a project that started in 2024 and finished in the period shows up. So does one I'm only a member of. Credit a project as mine only when `lead` is me. Say when most of its work happened before the period.
   - Leave canceled projects out of "Projects I led". Mention one only if PRs show real work on it.
2. Completed issues: `list_issues` with `assignee: "me"`, `state: "completed"`, `updatedAt: <start>`, fields `title, completedAt, project`, `limit: 250`.
   - The result is too large to return inline, so the tool saves it to a file. The JSON has the shape `{"issues": [...], "hasNextPage", "cursor"}`. Each issue's `project` is an object with a `name` field, or null.
   - Parse the file with `python3 -I`. Keep paging with `cursor` until `hasNextPage` is false. One page sorted by `updatedAt` holds only the last few months, which skews the review toward recent work.
3. Count issues per project. Read titles for issues with no project and for on-call projects. These hold the informal patterns.

## Step 3: Synthesize

- **Formal projects.** Projects I led, with dates. Back each one with the PRs that delivered it. Say concretely what shipped.
- **Patterns.** Clusters of similar work outside formal projects, such as security patching, release engineering, on-call reliability fixes, or tooling. Give approximate counts and representative examples.
- **Highlights.** Pick the 3–5 strongest items for a review. Say why each one stands out: a customer driver, cross-team impact, a clear before and after, or sustained effort.
- **Caveats.** Name any data limits you hit.

Backports and cherry-picks repeat the same title across release branches. Count unique titles when you quote the size of a pattern. Treat the repeats as proof of cross-branch work, not as separate items.

Sweeping chores spread across many repos (CODEOWNERS migrations, pinning an action after a supply-chain advisory) count as one item. They can still be a highlight when they show a fast response.

Read PRs and Linear together. A Linear project names the goal, and its PRs show what shipped. On-call issues with no project often match a run of `fix(...)` PRs. Group those into a reliability pattern.

Don't invent metrics. Mark impact claims that need a number I can look up, such as alert noise or patch turnaround.

## Step 4: Write the report

Write one Markdown file with this structure:

```markdown
---
title: Work review <start> to <end>
date: <today>
period_start: <start>
period_end: <end>
tags: [work-review]
---

# Work review: <start> to <end>

## Summary
<PR count, repo count, projects led and completed. 2–3 sentences.>

## Projects I led
| Project | When | What shipped |
|---|---|---|

## Contribution patterns
### <Pattern name> (~N PRs)
- <Concrete examples with PR links>

## Highlights for review
1. **<Item>.** <Why it stands out.>

## Metrics to gather
- <Claims that need a number>

## Caveats
- <Data limits>

## Appendix: PRs by repo
| Repo | Merged PRs |
|---|---|
```

Link PRs as `[repo#123](url)` and Linear projects by URL. Use the `prefect-internal-skills:writing` voice: plain words, short sentences, no promotional language.

Reply with the file path and the highlights list only.
