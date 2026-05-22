-- Disable Vim's built-in netrw file browser. We use neo-tree instead, and
-- netrw otherwise hijacks any `:e <directory>` command and fights neo-tree.
-- Must be set early (before netrw would load).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Indentation (global default; per-filetype overrides live in ftplugin/)
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Line numbers (hybrid: relative everywhere, absolute on current line)
vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Lowered from default 1000 so which-key (and any multi-key motion) feels snappy.
vim.opt.timeoutlen = 500

-- One global statusline across all splits, instead of one per window.
vim.opt.laststatus = 3

-- Persistent undo
vim.opt.undofile = true

-- Clipboard: intentionally NOT unified with system clipboard.
-- Use "+y / "+p to cross the boundary explicitly.

-- Treesitter-based folding: functions, blocks, and structs become foldable
-- units. zc closes a fold, zo opens, zM closes all, zR opens all.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Start with all folds open. Without this, opening a file shows everything
-- collapsed (very disorienting).
vim.opt.foldlevelstart = 99
