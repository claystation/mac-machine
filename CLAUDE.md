# CLAUDE.md

Context for future Claude sessions working in this repo.

## What this is

macOS dotfiles managed with [chezmoi](https://chezmoi.io). Source state lives in `~/.local/share/chezmoi`; the remote is `github.com/claystation/mac-machine`. This is a **work computer** — treat the repo as semi-public.

## Privacy rules (hard constraints — re-validate before pushing)

- **Zero PII in source state.** No personal or work emails, real names, GPG fingerprints, or `/Users/<username>/...` paths.
- **Zero employer-internal references.** No internal URLs (wikis, dashboards, services), no internal project IDs, no internal CLI names without a `command -v` guard, no naming the employer.
- Personal + work git identities are templated via `.chezmoi.toml.tmpl` (prompts on `chezmoi init`); answers land in `~/.config/chezmoi/chezmoi.toml` (machine-local, never committed).
- Private URL rewrites (e.g. SSH rewrites for private GitHub orgs) live in `~/.gitconfig.local`, included from `dot_gitconfig.tmpl`, **gitignored from chezmoi**.
- `.env` values never tracked. `dot_env.example` lists variable names only, no example values.
- Run a sensitive-string scan before recommending a push: `git log --all -S "<pattern>"` for emails, GPG fingerprints, internal hostnames.

## Layout

- `dot_<name>` → applied to `~/.<name>` (chezmoi convention)
- `dot_<name>.tmpl` → templated, rendered at apply time using data from `~/.config/chezmoi/chezmoi.toml`
- `run_once_before_*` → bootstrap scripts, run **before** file laydown, only once per content hash
- `run_once_after_*` → bootstrap scripts, run **after** file laydown
- `run_onchange_*` → re-runs when the rendered content hash changes
- `.chezmoi.toml.tmpl` → executed on `chezmoi init`, prompts the user, writes `~/.config/chezmoi/chezmoi.toml`
- `.chezmoiignore` → excludes paths from both `chezmoi add` and apply

## Bootstrap chain (current order)

1. `run_once_before_generate-ssh-key.sh.tmpl` — interactive ed25519 key gen, enforced passphrase
2. `run_once_before_install-homebrew.sh`
3. `run_once_before_install-oh-my-zsh.sh`
4. files applied
5. `run_onchange_after_install-packages.sh.tmpl` — `brew bundle`
6. `run_once_after_install-mise-tools.sh` — `mise install` (slow on first run, 10–30 min)
7. `run_once_after_install-claude.sh`
8. `run_once_after_install-tpm.sh`

The repo clones over HTTPS (it's public), so the SSH key script can stay in the chain — it just generates a key for later use (pushing back here, private repos) rather than gating the clone.

## Tooling preferences (captured during setup — change with care)

- **Version manager: `mise`**, not asdf. Asdf was migrated out. Go tools live in `mise.toml` `[tools]` as `go:<package>` so they reinstall on Go version bumps.
- **`gcloud`**: brew cask `google-cloud-sdk`, not manual install. The `.zshrc` sources from `/opt/homebrew/share/google-cloud-sdk/`.
- **Claude Code CLI**: installed via Anthropic's `curl claude.ai/install.sh | bash`, **not** the brew cask.
- **Editor**: nvim (`EDITOR=nvim` in `.zshrc`; `chezmoi edit` honours it).
- **Shell framework**: oh-my-zsh. mise is loaded via the official oh-my-zsh `mise` plugin, not a manual `eval`.
- **No install scripts for internal tools** (e.g. the `workspace` CLI). Guard with `command -v` instead of attempting installation.

## Day-to-day commands

| Task | Command |
| --- | --- |
| Edit a tracked file | `chezmoi edit ~/.zshrc` → `chezmoi diff` → `chezmoi apply` |
| Add a new file | `chezmoi add ~/.path/to/file` |
| Apply files only (skip scripts) | `chezmoi apply --exclude=scripts` |
| Apply a single file | `chezmoi apply ~/.zshrc` |
| Refresh Brewfile | `brew bundle dump --file=$(chezmoi source-path)/Brewfile --force` |
| Drop into source repo | `chezmoi cd` |

`chezmoi diff` shows pending **scripts** as if they were file diffs — that's normal, applying them executes the script. Filter with `--exclude=scripts` when reviewing real file changes.

## Working in this repo

- Default to `chezmoi apply --exclude=scripts` on this machine. The `run_once_*` scripts are mostly idempotent but `mise install` is slow and `install-packages.sh` may try to install things this machine has another way (e.g. gcloud at `~/google-cloud-sdk`).
- Squashed git history is intentional (single `Initial commit`). If history needs cleaning again after sensitive content slips in, use orphan-branch + gc.
- Never bypass `.chezmoiignore` to add `.env`, `.ssh/`, or any path under `.config/{gcloud,gh,github-copilot}`.

## Keeping this file up to date

**Update CLAUDE.md when you:**
- Change the bootstrap chain (add/remove/rename a `run_once_*` or `run_onchange_*` script)
- Swap a major tool (e.g. another version manager change, different shell framework)
- Change the templating approach (new prompts in `.chezmoi.toml.tmpl`, new templated files)
- Change a privacy boundary (new gitignored file, new templated PII, change to the sensitive-string scan)
- Establish a new workflow constraint or convention the user has stated

**Don't update** for routine edits — typo fixes, a new alias, a new brew package, a new mise tool. Only when the conventions or structure change.
