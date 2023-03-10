-------------------------------------------------------------------------------
-- Vim Settings
-------------------------------------------------------------------------------
local opt = vim.opt

-- enable true color
opt.termguicolors = true
opt.cursorline = true
-- enable all mouse support
opt.mouse = "a"
-- 80 char column
opt.colorcolumn = "80"
-- line numbers
opt.number = true
opt.relativenumber = true
-- always show some lines above/below for context
opt.scrolloff = 5
-- remove the weird `~` at the end of buffers
-- Fill diff deletions with diagonal lines
opt.fillchars:append({ eob = " ", diff = "╱" })
-- show tabs and trailing spaces
opt.list = true
opt.listchars = { trail = "⯀", tab = "  ›" }
-- tab settings
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
-- replace tabs with spaces
opt.expandtab = true
-- better search settings
opt.ignorecase = true -- needed to make smartcase work
opt.smartcase = true
-- replace all occurences on the same line by default (s/ command)
opt.gdefault = true
-- better tab completion
opt.wildmode = { "longest", "list" }
-- change splitting behaviour
opt.splitright = true
opt.splitbelow = true
-- enable systemm clipboard
opt.clipboard:append("unnamedplus")
opt.updatetime = 500
opt.timeoutlen = 0

-- my preferred diff options
opt.diffopt = { "internal", "closeoff", "filler", "vertical" }

-------------------------------------------------------------------------------
-- Vim Key bindings
-------------------------------------------------------------------------------
local map_key = vim.keymap.set
vim.g.mapleader = " "

-- easy window navigation
map_key("n", "<C-J>", "<C-W><C-J>", { noremap = true, silent = true })
map_key("n", "<C-K>", "<C-W><C-K>", { noremap = true, silent = true })
map_key("n", "<C-L>", "<C-W><C-L>", { noremap = true, silent = true })
map_key("n", "<C-H>", "<C-W><C-H>", { noremap = true, silent = true })
-- maximixe window
map_key("n", "<Leader>m", ":res<CR>", { noremap = true, silent = true, desc = "maximize current window" })
-- back to equal window sizes
map_key("n", "<Leader>n", "<C-W>=", { noremap = true, silent = true, desc = "normalize all window sizes" })

-- edit nvim config
map_key(
	"n",
	"<Leader>c",
	":e ~/.config/nvim/init.lua<CR>",
	{ noremap = true, silent = true, desc = "edit neovim config" }
)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup({

	-- Restore cursor position when reopening file
	"farmergreg/vim-lastplace",

	-- copy over ssh with ansi control code
	{
		"ojroques/nvim-osc52",

		config = function()
			local map_key = vim.keymap.set
			map_key(
				"v",
				"<Leader>y",
				require("osc52").copy_visual,
				{ noremap = true, silent = true, desc = "osc52 copy" }
			)
		end,
	},

	-- automatic basic language support for many languages
	-- (provides more robust indentation than tree-sitter)
	-- NOTE: maybe only use regex based indentation for python?
	"sheerun/vim-polyglot",

	-- proper grammar parsing
	{
		"nvim-treesitter/nvim-treesitter",

		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					-- enables traditional regex syntax highlighting needed by vim-polyglot indentation
					additional_vim_regex_highlighting = true,
				},
				-- vim-polyglot indentation is much more robust than tree-sitter currently
				indent = { enable = false },
			})
		end,
	},

	-- nordfox colorscheme
	{
		"EdenEast/nightfox.nvim",

		-- Make sure we load the colorscheme early
		lazy = false,
		priority = 1000,

		build = function()
			local nightfox = require("nightfox")
			nightfox.init({ styles = { keywords = "italic" } })
			nightfox.compile()
		end,

		config = function()
			vim.cmd("colorscheme nordfox")
		end,
	},

	-- highlight word under curosr
	{
		"RRethy/vim-illuminate",

		config = function()
			vim.g.Illuminate_delay = 500
		end,
	},

	-- colorize color codes
	{
		"norcalli/nvim-colorizer.lua",

		config = function()
			require("colorizer").setup()
		end,
	},

	-- indentation lines
	{
		"lukas-reineke/indent-blankline.nvim",

		config = function()
			require("indent_blankline").setup({
				char = "│",
				show_trailing_blankline_indent = false,
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},

	-- git annotations
	{
		"lewis6991/gitsigns.nvim",

		dependencies = "nvim-lua/plenary.nvim",

		config = function()
			require("gitsigns").setup()
		end,
	},

	-- git utilities
	"tpope/vim-fugitive",

	-- highlight TODO comments
	{
		"folke/todo-comments.nvim",

		dependencies = "nvim-lua/plenary.nvim",

		config = function()
			require("todo-comments").setup({
				highlight = {
					pattern = [[<(KEYWORDS)>]],
					keyword = "bg",
				},
			})
		end,
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",

		dependencies = {
			"kyazdani42/nvim-web-devicons",
			"SmiteshP/nvim-navic", -- lsp bread crumbs
		},

		config = function()
			local navic = require("nvim-navic")

			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "Outline" },
				},

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = {
						{ navic.get_location, cond = navic.is_available },
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},

				inactive_sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},

				-- wait until tabline can be shown only when there are multiple tabs
				-- tabline = {
				-- 	lualine_a = { {
				-- 		"tabs",
				-- 		mode = 2,
				-- 		max_length = function()
				-- 			return vim.o.columns
				-- 		end,
				-- 	} },
				-- 	lualine_b = {},
				-- 	lualine_c = {},
				-- 	lualine_x = {},
				-- 	lualine_y = {},
				-- 	lualine_z = {},
				-- },
			})
		end,
	},

	-- file tree
	{
		"kyazdani42/nvim-tree.lua",

		dependencies = "kyazdani42/nvim-web-devicons",

		config = function()
			local nvim_tree = require("nvim-tree")

			-- work-around to have NvimTree auto start
			vim.api.nvim_create_autocmd("VimEnter", {
				pattern = "*",
				-- # NOTE: `require("nvim-tree").open` doesn't seem to work
				command = "NvimTreeOpen",
			})
			vim.api.nvim_create_autocmd("VimEnter", {
				pattern = "*",
				command = "wincmd p",
			})

			nvim_tree.setup({
				renderer = { indent_markers = { enable = true }, highlight_git = true },
				-- doesn't do what we want
				--open_on_setup = true,
			})

			local map_key = vim.keymap.set
			map_key("n", "<Leader>g", function()
				nvim_tree.find_file()
				nvim_tree.focus()
			end, { noremap = true, silent = true, desc = "find file in tree" })
		end,
	},

	-- original fzf
	{
		"junegunn/fzf.vim",

		dependencies = "junegunn/fzf",

		init = function()
			vim.g.fzf_layout = { window = { width = 0.9, height = 0.7 } }
			vim.g.fzf_command_prefix = "Fzf"
		end,
	},

	-- finder for various lists
	{
		"nvim-telescope/telescope.nvim",

		branch = "0.1.x",

		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"smartpde/telescope-recent-files",
			"nvim-telescope/telescope-symbols.nvim",
		},

		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
						},
					},
					layout_strategy = "flex",
					layout_config = {
						prompt_position = "top",
					},
					sorting_strategy = "ascending",
				},
				pickers = {
					diagnostics = {
						bufnr = 0, -- use only current buffer diagnostics
					},
					jumplist = {
						fname_width = 100, -- use more space to display file name
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("recent_files")
		end,
	},

	-- hook neovim's builtin ui elements
	"stevearc/dressing.nvim",

	-- simple key bindings menu
	{
		"folke/which-key.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
			"junegunn/fzf.vim",
			"neovim/nvim-lspconfig",
		},

		config = function()
			local wk = require("which-key")
			local telescope_builtin = require("telescope.builtin")
			local telescope = require("telescope")

			wk.setup({
				plugins = {
					marks = false,
					registers = false,
					presets = {
						operators = false,
						motions = false,
						text_objects = false,
						windows = false,
						nav = false,
						z = false,
						g = false,
					},
				},
			})

			wk.register({
				["<leader>"] = {
					l = {
						name = "LSP",
						d = { telescope_builtin.lsp_definitions, "definitions" },
						r = { telescope_builtin.lsp_references, "references" },
						s = { telescope_builtin.lsp_document_symbols, "document symbols" },
						w = { telescope_builtin.lsp_workspace_symbols, "workspace symbols" },
						e = { telescope_builtin.diagnostics, "document diagnostics" },
						n = {
							function()
								vim.lsp.buf.rename()
							end,
							"rename symbol",
						},
						f = {
							function()
								vim.lsp.buf.format()
							end,
							"auto-format",
							-- TODO: doesn't seem to work properly in visual mode
							mode = { "n", "v" },
						},
						h = {
							function()
								vim.lsp.buf.hover()
							end,
							"hover symbol",
						},
						o = { "<cmd>SymbolsOutline<cr>", "symbols outline" },
					},
					j = {
						name = "Vim",
						l = { telescope_builtin.current_buffer_fuzzy_find, "buffer lines" },
						b = { telescope_builtin.builtin, "telescope builtins" },
						h = { telescope_builtin.help_tags, "vim help tags" },
						c = { telescope_builtin.commands, "vim commands" },
						j = { telescope_builtin.jumplist, "vim jumps" },
						o = { telescope.extensions.recent_files.pick, "recent files" },
						f = { "<cmd>FzfFiles<cr>", "files" },
						r = { "<cmd>FzfRg<cr>", "file contents" },
						s = { telescope_builtin.symbols, "unicode symbols" },
					},
				},
			})
		end,
	},

	-- diff view
	{
		"sindrets/diffview.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
		},
	},

	-- completion engine
	{
		"hrsh7th/nvim-cmp",

		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-cmdline",
			"dmitmel/cmp-cmdline-history",

			-- snippets
			{
				"saadparwaiz1/cmp_luasnip",
				dependencies = {
					-- nice snippet collection
					"rafamadriz/friendly-snippets",
					-- we revert the dependency, so we can easly get the path to `friendly-snippets`
					dependencies = "L3MON4D3/LuaSnip",
					config = function(friendly_snippets)
						-- setup friendly-snippets
						require("luasnip.loaders.from_vscode").lazy_load({ paths = { friendly_snippets.dir } })
					end,
				},
			},
		},

		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local next_fun = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end

			local prev_fun = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end

			local mapping = {
				["<Tab>"] = cmp.mapping(next_fun, { "i", "s", "c" }),
				["<C-j>"] = cmp.mapping(next_fun, { "i", "s", "c" }),

				["<S-Tab>"] = cmp.mapping(prev_fun, { "i", "s", "c" }),
				["<C-k>"] = cmp.mapping(prev_fun, { "i", "s", "c" }),

				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}

			local formatting = {
				format = require("lspkind").cmp_format({
					maxwidth = 50,
					preset = "codicons",
					menu = {
						nvim_lsp = "[LSP]",
						buffer = "[Buffer]",
						path = "[Path]",
						nvim_lua = "[Lua]",
						luasnip = "[LuaSnip]",
						cmdline = "[CmdLine]",
						cmdline_history = "[CmdLineHistory]",
					},
				}),
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "luasnip" },
				}),
				mapping = cmp.mapping.preset.insert(mapping),
				formatting = formatting,
			})

			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "cmdline" },
					{ name = "cmdline_history" },
				}),
				mapping = cmp.mapping.preset.cmdline(mapping),
				formatting = formatting,
			})

			cmp.setup.cmdline("/", {
				sources = cmp.config.sources({
					{ name = "buffer" },
					{ name = "cmdline_history" },
				}),
				mapping = cmp.mapping.preset.cmdline(mapping),
				formatting = formatting,
			})

			cmp.setup.cmdline("?", {
				sources = cmp.config.sources({
					{ name = "buffer" },
					{ name = "cmdline_history" },
				}),
				mapping = cmp.mapping.preset.cmdline(mapping),
				formatting = formatting,
			})
		end,
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",

		dependencies = {

			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"kosayoda/nvim-lightbulb",
			"ray-x/lsp_signature.nvim",
			{
				"weilbith/nvim-code-action-menu",
				cmd = "CodeActionMenu",
			},
			"simrat39/symbols-outline.nvim",
			{
				-- display diagnostics
				"folke/trouble.nvim",
				dependencies = "kyazdani42/nvim-web-devicons",
			},
			"folke/neodev.nvim",
			{
				"jose-elias-alvarez/null-ls.nvim",
				dependencies = "nvim-lua/plenary.nvim",
			},
			{
				"williamboman/mason-lspconfig.nvim",
				dependencies = {
					"williamboman/mason.nvim",
					"neovim/nvim-lspconfig",
				},
			},
			{
				"jay-babu/mason-null-ls.nvim",
				dependencies = {
					"williamboman/mason.nvim",
					"jose-elias-alvarez/null-ls.nvim",
				},
			},
		},

		config = function()
			-- some seful LSP commands
			vim.api.nvim_create_user_command("LspFormat", function()
				vim.lsp.buf.format()
			end, { desc = "Format buffer using LSP servers." })

			vim.api.nvim_create_user_command("LspRename", function()
				vim.lsp.buf.rename()
			end, { desc = "Rename symbol using LSP servers." })

			vim.api.nvim_create_user_command("LspHover", function()
				vim.lsp.buf.hover()
			end, { desc = "Show info at cursor using LSP." })

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				pattern = "*",
				callback = require("nvim-lightbulb").update_lightbulb,
			})

			require("lsp_signature").setup({})

			require("symbols-outline").setup({
				relative_width = false,
				width = 30,
				symbol_blacklist = {
					"Variable",
				},
			})

			require("trouble").setup({
				-- use "document_diagnostics" by default
				mode = "document_diagnostics",
				-- use my own defined signs
				use_diagnostic_signs = true,
			})

			require("neodev").setup({
				setup_jsonls = false,
				override = function(root_dir, library)
					-- enable it for all lua files
					library.enabled = true
					library.runtime = true
					library.types = true
					library.plugins = true
				end,
			})

			-- null-ls isn't supported by lspconfig
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.stylua,
				},
			})

			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-null-ls").setup({
				ensure_installed = nil,
				automatic_installation = true,
				automatic_setup = false,
			})

			local lsp_zero = require("lsp-zero")

			lsp_zero.set_preferences({
				suggest_lsp_servers = true,
				setup_servers_on_start = true,
				set_lsp_keymaps = false,
				configure_diagnostics = true,
				cmp_capabilities = true,
				manage_nvim_cmp = false,
				call_servers = "local",
				sign_icons = {
					error = "",
					warn = "",
					hint = "",
					info = "",
				},
			})

			lsp_zero.ensure_installed({
				"pyright",
				"clangd",
				"sumneko_lua",
				"rust_analyzer",
				"fortls",
				"ltex",
				"texlab",
				"bashls",
				"cmake",
				"yamlls",
			})

			local navic = require("nvim-navic")
			lsp_zero.on_attach(function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					-- attach navic if there's a suitable language server
					navic.attach(client, bufnr)
				end
			end)

			lsp_zero.setup()

			-- lsp_zero disables virtual text, reenable it
			vim.diagnostic.config({ virtual_text = true })
		end,
	},
})

-- vim: noexpandtab tabstop=2 shiftwidth=2
