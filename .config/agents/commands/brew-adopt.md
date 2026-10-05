---
description: Adopt untracked Homebrew packages into the split Brewfiles
argument-hint: "[classification notes]"
---

Adopt Homebrew entries installed on this machine but not tracked in the active split Brewfile.

User notes: $ARGUMENTS

Steps:

1. Work from the repository root.
2. Run `./bin/brew-drift-manifest --format json`.
3. Use `installed_not_in_active_bundle` as the adoption queue.
4. Read `.config/brew/Brewfile.common`, `.config/brew/Brewfile.work`, and `.config/brew/Brewfile.personal` before editing.
5. Edit only those three split Brewfiles.
6. Do not edit `.config/brew/Brewfile` or `.config/brew/Brewfile.snapshot`.
7. Do not commit.

Classification rules:

- Put entries in `Brewfile.common` when they support the shared shell, editor, agent, or developer workflow on every machine.
- Put entries in `Brewfile.work` when they are for work accounts, cloud infrastructure, Kubernetes, Terraform, company collaboration, or work-only apps.
- Put entries in `Brewfile.personal` when they are for personal media, home tooling, hobby apps, personal accounts, or Mac App Store apps.
- Prefer `common` or the active overlay unless there is clear evidence an entry belongs in the inactive overlay. Do not put an active-machine entry in an inactive overlay based on category alone.
- If an entry is already tracked only outside the active overlay, move it to `common` only when it truly belongs everywhere. Otherwise leave it alone and report it as cross-overlay drift.
- If an entry is ambiguous or looks like a temporary trial, leave it unmodified and list it in the final summary.
- Treat orphan taps and temporary app variants, such as nightly/beta casks, as cleanup candidates. Do not adopt them, uninstall them, or untap them unless the user explicitly asks.

Editing rules:

- Preserve the exact Brewfile line from the manifest, including options like `trusted: true`, `args:`, and `link: false`.
- Copy the manifest comment above the inserted line when one exists.
- If no comment exists, either omit the comment or verify a description with Homebrew before adding one.
- Add tap entries to the same Brewfile as the package that needs that tap.
- Keep existing grouping: taps first, then formulae, then casks, then vscode/go/npm entries.
- Place entries near related entries or in the local alphabetical area when there is no better grouping.

Finish by running `git diff --stat -- .config/brew/Brewfile.common .config/brew/Brewfile.work .config/brew/Brewfile.personal` and summarizing what changed, what was left ambiguous, and any active tracked entries that are not installed.
