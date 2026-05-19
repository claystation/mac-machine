# mac-machine

My macOS dotfiles, managed with [chezmoi](https://chezmoi.io).

## Fresh-machine install

```sh
# 1. Install chezmoi (requires Xcode CLT — `xcode-select --install` if missing)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# 2. Pull and apply (public repo — no GitHub auth needed for the clone)
chezmoi init --apply https://github.com/claystation/mac-machine.git
```

The `init --apply` step runs the bootstrap scripts in this order:

1. `run_once_before_generate-ssh-key.sh.tmpl` — interactively generates a passphrase-protected `ed25519` key at `~/.ssh/id_ed25519` if missing (skips silently otherwise); prints the public key for you to add to GitHub
2. `run_once_before_install-homebrew.sh` — installs Homebrew (no-op if already present)
3. `run_once_before_install-oh-my-zsh.sh` — installs oh-my-zsh (keeps the chezmoi-managed `.zshrc`)
4. files written into `~/` (`.zshrc`, `.gitconfig`, `.config/{nvim,tmux,zsh}`, oxide theme)
5. `run_onchange_after_install-packages.sh.tmpl` — `brew bundle` from the embedded `Brewfile` (installs gcloud among other things)
6. `run_once_after_install-mise-tools.sh` — runs `mise install` to provision every runtime + Go tool from `~/.config/mise/config.toml` (slow on first run)
7. `run_once_after_install-claude.sh` — installs Claude Code via Anthropic's `claude.ai/install.sh` (lands at `~/.local/bin/claude`)
8. `run_once_after_install-tpm.sh` — clones TPM and installs the tmux plugins from `tmux.conf`

After that, open a new shell. Inside tmux, plugins should already be live; if not, hit `prefix + I`.

## Things that are NOT in this repo (intentionally)

These need to be set up by hand on a new machine:

- **`~/.env`** — sourced by `.zshrc`, holds personal env vars / secrets. See `~/.env.example` (laid down by chezmoi) for the list of variables; copy it to `~/.env` and fill in real values.
- **`~/.ssh/`** — copy keys over, or generate new ones and re-add to GitHub.
- **`~/.gnupg/`** — GPG signing key (referenced by `.gitconfig` if you provide one at `chezmoi init`). Either restore from backup or import: `gpg --import private-key.asc`.
- **`gh auth login`** — GitHub CLI auth.
- **`gcloud auth login` + `gcloud auth application-default login`** — Google Cloud auth. Alias `gcauth` runs `gcloud auth login --update-adc`.
- **GitHub Copilot in editor** — re-auth.

### `chezmoi init` will prompt for

- Personal git email + name (used in `~/.gitconfig`)
- Work git email + name (used in `~/.gitconfig-nn`, included for repos under `~/projects/` and `~/workspaces/`)
- GPG signing key ID (optional — leave empty to skip commit signing)

These get written to `~/.config/chezmoi/chezmoi.toml` (NOT in this repo) and rendered into the gitconfigs at apply time.

## Day-to-day

| Task | Command |
| --- | --- |
| Edit a tracked file | `chezmoi edit ~/.zshrc` (then `chezmoi apply`) |
| Track a new file | `chezmoi add ~/.config/foo` |
| See what would change | `chezmoi diff` |
| Pull upstream changes | `chezmoi update` |
| Refresh the Brewfile | `brew bundle dump --file=$(chezmoi source-path)/Brewfile --force` |
| Drop into the source repo | `chezmoi cd` |

## What's tracked

- `.zshrc`, `.gitconfig`, `.gitconfig-nn` (the gitconfigs are templates — values come from `chezmoi init` prompts)
- `.config/nvim/` — kickstart.nvim + customisations under `lua/custom/`
- `.config/tmux/{tmux.conf,project-picker.sh}`
- `.config/zsh/aliases`
- `.config/mise/config.toml` — mise-managed runtimes (go, node, java, maven, python, terraform, groovy, yarn) **and** global Go tools (dlv, gopls, staticcheck, etc.) that get re-installed automatically on `go` version bumps
- `Brewfile` (regenerate as above when packages change)
- `.oh-my-zsh/custom/themes/oxide.zsh-theme`

See `.chezmoiignore` for everything excluded (secrets, ephemeral state, vendored plugin dirs).
