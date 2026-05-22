# Neovim Keybind Cheatsheet

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | n | Move between splits |
| `<C-d>` | n | Half-page down, centered |
| `<C-u>` | n | Half-page up, centered |
| `n` | n | Next search match, centered |
| `N` | n | Prev search match, centered |
| `<Esc>` | n | Clear search highlight |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `<` / `>` | v | Indent left/right, keep selection |
| `<A-j>` | n, v | Move line/selection down |
| `<A-k>` | n, v | Move line/selection up |

## Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<S-h>` | n | Previous buffer |
| `<S-l>` | n | Next buffer |
| `<leader>x` | n | Close buffer |

## Telescope (`<leader>f`)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fw` | Grep word under cursor |
| `<leader>fd` | Diagnostics |

## Neo-tree (`<leader>e`)

| Key | Action |
|-----|--------|
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Focus file explorer |

## LSP

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `K` | n | Hover documentation | built-in |
| `gd` | n | Go to definition | our binding |
| `grr` | n | References | built-in |
| `gri` | n | Implementation | built-in |
| `grn` | n | Rename | built-in |
| `gra` | n | Code action | built-in |
| `grt` | n | Type definition | built-in |
| `gO` | n | Document symbols | built-in |
| `<C-S>` | i | Signature help | built-in |

## Diagnostics (`<leader>c` + jump)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cd` | n | Line diagnostics float |
| `]d` | n | Next diagnostic, centered |
| `[d` | n | Prev diagnostic, centered |

## Completion (blink.cmp)

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | i | Accept completion / snippet next placeholder / fallback |
| `<S-Tab>` | i | Snippet prev placeholder / fallback |
| `<A-c>` | i | Toggle completion menu + docs |
| `<C-n>` | i | Next item in menu |
| `<C-p>` | i | Prev item in menu |
| `<CR>` | i | Accept completion |
| `<C-e>` | i | Dismiss menu |

## Git (gitsigns, `<leader>g`)

| Key | Mode | Action |
|-----|------|--------|
| `]c` | n | Next git hunk |
| `[c` | n | Prev git hunk |
| `<leader>gs` | n, v | Stage hunk / selection |
| `<leader>gr` | n, v | Reset hunk / selection |
| `<leader>gS` | n | Stage entire buffer |
| `<leader>gu` | n | Undo stage hunk |
| `<leader>gp` | n | Preview hunk (float) |
| `<leader>gb` | n | Blame current line |
| `<leader>gd` | n | Diff buffer vs HEAD |

## Formatting (conform)

| Key / Command | Action |
|---------------|--------|
| `:w` | Auto-formats (format on save) |
| `<leader>cf` | Format buffer / visual selection |
| `:FormatDisable` | Disable autoformat (session) |
| `:FormatDisable!` | Disable autoformat (buffer only) |
| `:FormatEnable` | Re-enable autoformat |

## Folding (treesitter-backed)

| Key | Action |
|-----|--------|
| `zc` | Close fold under cursor |
| `zo` | Open fold under cursor |
| `za` | Toggle fold |
| `zM` | Close all folds in file |
| `zR` | Open all folds |

## Plugins

| Key | Action |
|-----|--------|
| `<leader>pu` | Update all plugins |

## Quick-close windows

| Key | Where | Action |
|-----|-------|--------|
| `q` | help, quickfix, man, lspinfo | Close the window |
