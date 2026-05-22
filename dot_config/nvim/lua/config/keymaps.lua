-- Press Esc in normal mode to clear search highlighting.
-- (Esc in normal mode otherwise does nothing useful; this is "free" key real estate.)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Keep selection after indent/dedent in visual mode (default loses it).
vim.keymap.set("v", "<", "<gv", { desc = "Indent left, keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Move between splits with Ctrl+hjkl instead of the Ctrl+w prefix.
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Recenter the screen on cursor after half-page scrolls.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, recenter" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, recenter" })

-- Move current line (normal) or selection (visual) up/down with Alt+j/k.
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Cycle buffers with Shift+h / Shift+l.
-- NOTE: this overwrites the default H/L (jump to top/bottom of screen).
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bp | bd #<CR>", { desc = "Close buffer" })
