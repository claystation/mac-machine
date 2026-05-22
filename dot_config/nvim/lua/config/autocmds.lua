-- Brief flash on the region you just yanked, so you can see what was copied.
-- Without this, `yap` (yank a paragraph) gives zero visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- Jump to the last cursor position when reopening a file.
-- Neovim remembers per-file marks in its ShaDa file (persistent undo's
-- cousin). The `"` mark is "where you were when you left." This reads it
-- on open and jumps there — saves you scrolling every time.
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Equalize splits when the terminal is resized. Without this, making
-- iTerm2 wider gives all the extra space to one split.
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Auto-create parent directories when saving a file to a path that
-- doesn't exist yet. e.g. `:e some/new/dir/file.lua` then `:w` just works
-- instead of erroring with "E212: Can't open file for writing."
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		-- Skip URL-like paths (scp://, fugitive://, oil://, etc.)
		if args.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local dir = vim.fn.fnamemodify(args.file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Press q to close quickfix / help / man / lspinfo windows. These are
-- read-only reference windows; reaching for :q every time is tedious.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help", "man", "lspinfo" },
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
	end,
})
