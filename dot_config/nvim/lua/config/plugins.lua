-- Install plugins via the built-in vim.pack manager (Neovim 0.12+).
-- vim.pack.add() clones any missing plugins to
--   ~/.local/share/nvim/site/pack/core/opt/
-- and adds them to the runtimepath. To update later: :lua vim.pack.update()
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	-- nvim-treesitter: we pin to the `main` branch (the rewrite). The default
	-- `master` branch is the legacy verions used by most older tutorials.
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("catppuccin").setup({
	flavour = "mocha", -- options: "latte" (light), "frappe", "macchiato", "mocha"
})

vim.cmd.colorscheme("catppuccin")

require("which-key").setup({})
require("which-key").add({
  { "<leader>f", group = "find" },
  { "<leader>e", group = "explorer" },
  { "<leader>g", group = "git" },
  { "<leader>c", group = "code" },
  { "<leader>p", group = "plugins" },
})

require("lualine").setup({
	options = {
		-- Catppuccin ships one theme file per flavor (catppuccin-mocha, -latte,
		-- -frappe, -macchiato). There is no plain "catppuccin" theme.
		theme = "catppuccin-mocha",
	},
	sections = {
		-- Left side
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },

		-- Right side
		lualine_x = {
			{
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					local names = {}
					for _, client in ipairs(clients) do
						table.insert(names, client.name)
					end
					return table.concat(names, ", ")
				end,
			},
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("mini.icons").setup({})
-- Many plugins still look for nvim-web-devicons by name. mini.icons can
-- impersonate it so they get our icons too.
require("mini.icons").mock_nvim_web_devicons()

require("telescope").setup({})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })

require("neo-tree").setup({
	-- Close Neovim if neo-tree is the last window open, so we don't end up
	-- staring at a lone tree after `:q`-ing everything else.
	close_if_last_window = true,
	window = {
		width = 30,
	},
})

vim.keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree focus<CR>", { desc = "Focus file explorer" })

require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
		end

		-- Navigation between hunks (changed regions)
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(gs.next_hunk)
		end, "Next git hunk")
		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(gs.prev_hunk)
		end, "Prev git hunk")

		-- Actions under <leader>g (git namespace)
		map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
		map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
		map("v", "<leader>gs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage selection")
		map("v", "<leader>gr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset selection")
		map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
		map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
		map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
		map("n", "<leader>gb", gs.blame_line, "Blame line")
		map("n", "<leader>gd", gs.diffthis, "Diff buffer")
	end,
})

-- Treesitter (main branch). Parsers are compiled C libs installed under
-- ~/.local/share/nvim/site/parser/. install() is async; first launch fetches
-- and compiles them in the background.
require("nvim-treesitter").setup({
	textobjects = {
		select = {
			enable = true,
		},
	},
})

require("nvim-treesitter").install({
	"lua",
	"vim",
	"vimdoc",
	"query",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"yaml",
	"terraform",
	"hcl",
	"bash",
	"markdown",
	"markdown_inline",
	"json",
	"jsonc",
	"typescript",
	"javascript",
	"tsx",
	"toml",
	"make",
	"dockerfile",
	"gitcommit",
	"gitignore",
	"diff",
})

-- Turn on treesitter highlighting whenever a buffer with an installed parser
-- is opened. pcall swallows "no parser for this filetype" errors silently.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- LSP servers are installed system-wide (brew/npm/cargo). nvim-lspconfig
-- ships lsp/<server>.lua files with sensible defaults that Neovim 0.11+
-- auto-loads. We only override per-server settings, then call enable().

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			-- Tell lua_ls that `vim` is a real global; otherwise it warns on
			-- every line of our config.
			diagnostics = { globals = { "vim" } },
			-- Make lua_ls aware of Neovim's runtime files so it can complete
			-- vim.api.*, vim.fn.*, etc.
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemas = {
				kubernetes = {
					"applications/manifests/**/*.yaml",
					"applications/kustomize/**/*.yaml",
				},
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
				["https://json.schemastore.org/docker-compose.json"] = {
					"docker-compose.{yml,yaml}",
					"compose.{yml,yaml}",
				},
				["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
				["https://json.schemastore.org/catalog-info.json"] = "catalog-info.yaml",
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "gopls", "yamlls", "terraformls", "bashls" })

-- conform.nvim runs external formatters per filetype. For filetypes not
-- listed here, we fall back to the LSP's own formatter (gopls, terraform-ls).
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		yaml = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		markdown = { "prettier" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		terraform = { "terraform_fmt" },
		tf = { "terraform_fmt" },
		hcl = { "terraform_fmt" },
		typescript = { "prettier" },
		javascript = { "prettier" },
		typescriptreact = { "prettier" },
	},

	-- Run on every :w. The function form lets us check an escape-hatch flag
	-- first; returning nil disables formatting for this save.
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return {
			timeout_ms = 1000,
			-- "fallback" = use LSP formatter if no entry in formatters_by_ft.
			-- This is what makes gopls handle Go automatically.
			lsp_format = "fallback",
		}
	end,
})

-- Escape hatches for the rare moment you don't want autoformat:
--   :FormatDisable        → off globally for this session
--   :FormatDisable!       → off only for this buffer
--   :FormatEnable         → back on (buffer + global)
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, { bang = true, desc = "Disable autoformat-on-save" })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

-- Manual format trigger, for when you want to format without saving.
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer/selection" })

local lint = require("lint")

-- nvim-lint runs external linters per filetype and shoves the results into
-- Neovim's diagnostic system (same UI as LSP diagnostics).
lint.linters_by_ft = {
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	markdown = { "markdownlint" },
}

-- nvim-lint doesn't auto-run; you trigger it. Run on save + when leaving
-- insert mode, so diagnostics stay fresh without spamming during typing.
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- How diagnostics are displayed. Defaults are fine; we tweak two things:
-- show diagnostic text as virtual text at end of line, and use a more
-- visible marker in the sign column.
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false, -- defer diagnostic updates while you're typing
	severity_sort = true,
})

-- Load friendly-snippets into LuaSnip. This is a one-time scan of all the
-- bundled snippet files; LuaSnip indexes them by filetype.
require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	-- Keymap preset: "default" gives us <C-Space> trigger, <C-e> dismiss, etc.
	-- Then we override <Tab> / <S-Tab> for accept + snippet navigation.
	keymap = {
		preset = "default",
		["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		["<A-c>"] = { "show", "show_documentation", "hide_documentation" },
	},

	-- Sources blink pulls completions from. Order = priority when scoring ties.
	sources = {
		default = { "lsp", "snippets", "path", "buffer" },
	},

	-- Tell blink to use LuaSnip instead of its built-in snippet engine, so the
	-- friendly-snippets we loaded above are available.
	snippets = { preset = "luasnip" },

	-- Auto-trigger as we type (this is the default; spelling it out for clarity).
	completion = {
		trigger = { show_on_keyword = true, show_on_trigger_character = true },
		-- Show docs preview window automatically (otherwise <C-Space> twice).
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
	},

	-- blink ships its own fuzzy matcher (the Rust binary). Use "prefer_rust" so
	-- it falls back to Lua if the binary ever fails to load.
	fuzzy = { implementation = "prefer_rust" },
})

--- Add a Telescope-powered diagnostics picker. K, gd, grr, grn, gra etc.
--- are built into Neovim already; we don't need to bind those ourselves.
-- Neovim 0.11+ binds these LSP actions out of the box: K (hover), grr
-- (references), gri (implementation), grn (rename), gra (code action), grt
-- (type definition), gO (document symbols), <C-S> in insert (sig help).
-- `gd` is NOT in that list — the vim built-in `gd` (regex search for the
-- word's local declaration) wins instead. Bind it explicitly to LSP.
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

-- Telescope-powered diagnostics picker.
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "Diagnostics" })

-- vim.pack operations under the <leader>p* namespace.
vim.keymap.set("n", "<leader>pu", vim.pack.update, { desc = "Update plugins" })
