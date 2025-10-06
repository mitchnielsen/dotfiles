Create a PR based on our current branch using the `gh` command-line tool.

Additional context from me to include in the PR and commit messages: $ARGUMENTS

Create a pull request from this branch in `draft` state. If there is a pull
request template file, usually in `.github/pull_request_template.md`, then
follow that template for the pull request title and body.

Then, use `gh pr create` to create the PR. If there is only a single
commit, use the commit message as the PR message. If there are multiple commits,
synthesize a new one that covers all of those changes.

## Commit/PR descriptions

- IMPORTANT: THIS STYLE GUIDE IS REQUIRED AND MANDATORY
- Be conversational and humble, avoid "comprehensive" or confident
  "root cause" claims, it highlights your Dunning-Kruger issues
- Brief, focus on what/why not how
- No checklists or file lists (but change lists OK)
- No "Test Plan" checklist
- Always mention related issues when available
  - Based on our conversation, use "Closes #1234" or "Closes ENG-1234"
- Include contextual links (logs, issues, PRs, materials) that would help a
  reviewer get oriented on what we're talking about
