---
name: commit-message
description: "Guide for writing git commit titles and messages following Conventional Commits format with session context"
user-invocable: false
---

# Commit Message Conventions

Use this skill when writing git commit messages. These conventions apply
to all commits regardless of how they are created (explicit commands,
ad-hoc requests, or any other workflow).

## Safety Rules

- NEVER amend or squash commits unless explicitly told to.
- NEVER use `git commit --no-verify`. Fix hook errors instead.
- Do not push until explicitly told to push.

## Title Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) format.

```
<type>(<scope>): <description>
```

Run `git log -n 50 --pretty=format:%s` to see commonly used scopes in
the current repository. Match existing conventions.

Examples:
- `docs: correct spelling of CHANGELOG`
- `feat(api): send an email to the customer when a product is shipped`
- `fix(auth): handle expired tokens on refresh`

## Body Guidelines

### What to include

- Focus on **what** changed and **why**, not how.
- Be conversational and humble. Avoid "comprehensive" or confident
  "root cause" claims.
- Keep it brief. 2-3 lines of session context in the body after the
  subject line.
- Include contextual links (logs, issues, PRs) that help a reviewer
  get oriented.
- Always mention related issues when available:
  `Closes #1234` or `Closes ENG-1234`.

### Session context

Include a brief summary of the development session that produced the
changes. Focus on context a reviewer would not get from reading the code:

- What kicked off the work
- Key decisions or trade-offs
- Alternatives rejected
- Anything surprising discovered along the way

### What NOT to include

- No checklists or file lists (change lists are fine).
- No "test plan" checklist.

## Determining Files to Commit

- If it is unclear whether a file should be included, ask the user.
- Never commit files that likely contain secrets (`.env`,
  `credentials.json`, etc). Warn the user if they specifically
  request to commit those files.

## Example

```
feat(ingest): add retry logic for transient upstream failures

Upstream API started returning 503s intermittently after their
maintenance window. Added exponential backoff with jitter capped
at 30s. Considered circuit-breaker but the failure rate is too
low to justify the complexity.

Closes ENG-4521
```
