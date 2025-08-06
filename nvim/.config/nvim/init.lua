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
-- hide cmdline if not in use
opt.cmdheight = 0
-- disable tabline becase we show tabs in the statusline instead
opt.showtabline = 0
-- enable systemm clipboard
opt.clipboard:append("unnamedplus")
opt.updatetime = 500
opt.timeoutlen = 0

-- my preferred diff options
opt.diffopt = { "internal", "closeoff", "filler", "vertical" }


-- make diagnostics float focusable
vim.diagnostic.config({
	float = {
		focusable = true,
		-- FIXME: doesn't seem to work
		-- maybe better to go through vim.lsp.util.open_floating_preview
		border = "solid",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN]  = "",
			[vim.diagnostic.severity.HINT]  = "",
			[vim.diagnostic.severity.INFO]  = "",
		}
	}
})

-------------------------------------------------------------------------------
-- Vim Key bindings
-------------------------------------------------------------------------------
local map_key = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- easy window navigation
map_key("n", "<C-J>", "<C-W><C-J>", { noremap = true, silent = true })
map_key("n", "<C-K>", "<C-W><C-K>", { noremap = true, silent = true })
map_key("n", "<C-L>", "<C-W><C-L>", { noremap = true, silent = true })
map_key("n", "<C-H>", "<C-W><C-H>", { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup({

	-- Restore cursor position when reopening file
	"farmergreg/vim-lastplace",

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
				-- TODO: indentation seems quite messy still
				-- TODO: probably need a proper auto-pairs plugin
				indent = { disable = { "python" } },
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
			require("nightfox").compile()
		end,

		config = function()
			local nightfox = require("nightfox")
			nightfox.setup({
				options = {
					dim_inactive = true,
					styles = { keywords = "italic" },
				},
			})
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

		main = "ibl",
		opts = {
			indent = { char = "┆", },
			whitespace = { remove_blankline_trail = true, },
		},
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

		opts = {
			highlight = {
				pattern = [[<(KEYWORDS)>]],
				keyword = "bg",
			},
		},
	},

	-- status line
	{
		"nvim-lualine/lualine.nvim",

		dependencies = {
			"kyazdani42/nvim-web-devicons",
			"SmiteshP/nvim-navic", -- lsp bread crumbs
		},

		opts = {
			options = {
				component_separators = "",
				section_separators = "",
				globalstatus = true,
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						"diff",
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					"%l:%c/%L",
					{ "filetype", icon_only = true },
					{ "filename", path = 1 },
				},
				lualine_c = {
					{ "navic" },
				},
				lualine_x = {},
				lualine_y = {
					{
						"tabs",
						mode = 2,
						cond = function()
							return 1 < #vim.api.nvim_list_tabpages()
						end,
						tabs_color = {
							active = "Normal",
						},
						section_separators = { right = "" },
						component_separators = { right = "╱" },
					},
				},
				lualine_z = {},
			},
		},
	},

	-- file tree
	{
		"kyazdani42/nvim-tree.lua",

		dependencies = "kyazdani42/nvim-web-devicons",

		config = function()
			local nvim_tree = require("nvim-tree")

			-- TODO: try out work-flow without opening file tree on startup
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
						flip_columns = 200,
						vertical = { mirror = true },
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
	-- FIXME: deprecated :(
	"stevearc/dressing.nvim",

	-- simple key bindings menu
	{
		"folke/which-key.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
			"junegunn/fzf.vim",
			"neovim/nvim-lspconfig",
			-- copy over ssh with ansi control code
			"ojroques/nvim-osc52",
		},

		config = function()
			local wk = require("which-key")
			local telescope_builtin = require("telescope.builtin")
			local telescope = require("telescope")
			local nvim_tree_api = require("nvim-tree.api")

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
				spec = {
					{ "<leader>l", group = "LSP" },
					{ "<leader>ld", telescope_builtin.lsp_definitions, desc = "definitions" },
					{ "<leader>lr", telescope_builtin.lsp_references, desc = "references" },
					{ "<leader>ls", telescope_builtin.lsp_document_symbols, desc = "document symbols" },
					{ "<leader>lw", telescope_builtin.lsp_workspace_symbols, desc = "workspace symbols" },
					{ "<leader>le", telescope_builtin.diagnostics, desc = "document diagnostics" },
					{ "<leader>ln",
						function()
							vim.lsp.buf.rename()
						end,
						desc = "rename symbol",
					},
					{ "<leader>lf",
						function()
							vim.lsp.buf.format()
						end,
						desc = "auto-format",
						-- TODO: doesn't seem to work properly in visual mode
						mode = { "n", "v" },
					},
					{ "<leader>lh",
						function()
							vim.lsp.buf.hover()
						end,
						desc = "hover symbol",
					},
					{ "<leader>lo", "<cmd>SymbolsOutline<cr>", desc = "symbols outline" },
					{ "<leader>la",
						function()
							local _, winid = vim.diagnostic.open_float({
								scope = "cursor",
							})
							-- focus it, so we can move around if the diagnostic is really big
							if winid ~= nil then
								vim.api.nvim_set_current_win(winid)
							end
						end,
						desc = "Show diagnostic of cursor in float",
					},
					{ "<leader>j", group = "Vim" },
					{ "<leader>jw", "<cmd>tabnew<cr>", desc = "create new tab page" },
					{ "<leader>jn", "<C-W>=", desc = "normalize all window sizes" },
					{ "<leader>jm", "<cmd>res<cr>", desc = "maximize current window" },
					{ "<leader>je", "<cmd>e ~/.config/nvim/init.lua<cr>", desc = "edit neovim config" },
					{ "<leader>jy", require("osc52").copy_visual, desc = "osc52 copy", mode = "v" },
					{ "<leader>jl", telescope_builtin.current_buffer_fuzzy_find, desc = "buffer lines" },
					{ "<leader>jb", telescope_builtin.builtin, desc = "telescope builtins" },
					{ "<leader>jh", telescope_builtin.help_tags, desc = "vim help tags" },
					{ "<leader>jc", telescope_builtin.commands, desc = "vim commands" },
					{ "<leader>jj", telescope_builtin.jumplist, desc = "vim jumps" },
					{ "<leader>jo", telescope.extensions.recent_files.pick, desc = "recent files" },
					{ "<leader>jf", "<cmd>FzfFiles<cr>", desc = "files" },
					{ "<leader>jr", "<cmd>FzfRg<cr>", desc = "file contents" },
					{ "<leader>js", telescope_builtin.symbols, desc = "unicode symbols" },
					{ "<leader>jg",
						function()
							-- FIXME: is broken if nvim-tree isn't open already (e.g., in new tab)
							nvim_tree_api.tree.find_file(vim.api.nvim_buf_get_name(0))
							nvim_tree_api.tree.focus()
						end,
						desc = "find file in tree",
					},
					{ "<leader>jt", nvim_tree_api.tree.toggle, desc = "toggle nvim-tree" },
					{ "<leader>jd", "<cmd>call setreg('+', line('.'))<cr>", desc = "copy current line number" },
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

	-- coq support
	{
		"tomtomjhj/coq-lsp.nvim",

		enabled = false, -- currently not needed

		dependencies = {
			{
				"whonore/Coqtail", -- for ftdetect, syntax, basic ftplugin, etc

				init = function()
					-- Don't load Coqtail
					vim.cmd([[
						let g:loaded_coqtail = 1
						let g:coqtail#supported = 0
					]])
				end,
			},
		},

		config = function()
			local coq_lsp = require("coq-lsp")
			coq_lsp.setup({
				lsp = { init_options = { show_notices_as_diagnostics = true } },
			})
			vim.api.nvim_create_user_command("CoqPanel", coq_lsp.panels, { desc = "Open coq panels" })
		end,
	},

	-- completion engine
	{
		"hrsh7th/nvim-cmp",

		dependencies = {
			"neovim/nvim-lspconfig",
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

				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),

				["<CR>"] = cmp.mapping.confirm(),
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
				preselect = cmp.PreselectMode.None,
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
					{ name = "path" },
				}),
				mapping = cmp.mapping.preset.cmdline(mapping),
				formatting = formatting,
			})

			cmp.setup.cmdline({"/", "?"}, {
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
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",

			"hrsh7th/cmp-nvim-lsp",
			"kosayoda/nvim-lightbulb",
			"ray-x/lsp_signature.nvim",
			{
				-- FIXME: deprecated, replace with "aznhe21/actions-preview.nvim"?
				"weilbith/nvim-code-action-menu",
				cmd = "CodeActionMenu",
			},
			-- FIXME: deprecated, alternatives "hedyhli/outline.nvim", "stevearc/aerial.nvim"
			"simrat39/symbols-outline.nvim",
			{
				-- display diagnostics
				"folke/trouble.nvim",
				dependencies = "kyazdani42/nvim-web-devicons",
				cmd = "Trouble",
				opts = {
					modes = {
						diagnostics_buffer = {
							mode = "diagnostics", -- inherit from diagnostics mode
							filter = { buf = 0 }, -- filter diagnostics to the current buffer
						},
					}
				},
			},
			{ "SmiteshP/nvim-navic", opts = { lsp = { auto_attach = true } } },
			--{
			--	"jay-babu/mason-null-ls.nvim",
			--	dependencies = {
			--		"williamboman/mason.nvim",
			--		"jose-elias-alvarez/null-ls.nvim",
			--	},
			--},
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

			--require("neodev").setup({
			--	setup_jsonls = false,
			--	override = function(root_dir, library)
			--		-- enable it for all lua files
			--		library.enabled = true
			--		library.runtime = true
			--		library.types = true
			--		library.plugins = true
			--	end,
			--})

			--local lsp_zero = require("lsp-zero")

			--lsp_zero.set_preferences({
			--	suggest_lsp_servers = true,
			--	setup_servers_on_start = true,
			--	set_lsp_keymaps = false,
			--	configure_diagnostics = true,
			--	cmp_capabilities = true,
			--	manage_nvim_cmp = false,
			--	call_servers = "local",
			--	sign_icons = {
			--		error = "",
			--		warn = "",
			--		hint = "󰌵",
			--		info = "",
			--	},
			--})

			--lsp_zero.ensure_installed({
			--	"pyright",
			--	"clangd",
			--	"lua_ls",
			--	"rust_analyzer",
			--	"fortls",
			--	"ltex",
			--	"texlab",
			--	"bashls",
			--	"cmake",
			--	"yamlls",
			--})

			require("mason-lspconfig").setup()

			-- FIXME: pass nvim-cmp capabilities to lsp
			---- Set up lspconfig.
			--local capabilities = require('cmp_nvim_lsp').default_capabilities()
			---- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
			--require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
			--	capabilities = capabilities
			--}

			--lsp_zero.setup()

			-- lsp_zero disables virtual text, reenable it
			vim.diagnostic.config({ virtual_text = true })
		end,
	},

	--{
	--	-- FIXME: deprecated :(
	--	"VonHeikemen/lsp-zero.nvim",
	--	-- FIXME: update to "v2.x"
	--	branch = "v1.x",

	--	dependencies = {

	--		"hrsh7th/cmp-nvim-lsp",
	--		"kosayoda/nvim-lightbulb",
	--		"ray-x/lsp_signature.nvim",
	--		{
	--			-- FIXME: deprecated, replace with "aznhe21/actions-preview.nvim"?
	--			"weilbith/nvim-code-action-menu",
	--			cmd = "CodeActionMenu",
	--		},
	--		"simrat39/symbols-outline.nvim",
	--		{
	--			-- display diagnostics
	--			"folke/trouble.nvim",
	--			dependencies = "kyazdani42/nvim-web-devicons",
	--			cmd = "Trouble",
	--			opts = {
	--				modes = {
	--					diagnostics_buffer = {
	--						mode = "diagnostics", -- inherit from diagnostics mode
	--						filter = { buf = 0 }, -- filter diagnostics to the current buffer
	--					},
	--				}
	--			},
	--		},
	--		-- FIXME: deprecated, replace with "folke/lazydev.nvim"?
	--		--"folke/neodev.nvim",
	--		--{
	--		--	"jose-elias-alvarez/null-ls.nvim",
	--		--	dependencies = "nvim-lua/plenary.nvim",
	--		--},
	--		--{
	--		--	"jay-babu/mason-null-ls.nvim",
	--		--	dependencies = {
	--		--		"williamboman/mason.nvim",
	--		--		"jose-elias-alvarez/null-ls.nvim",
	--		--	},
	--		--},
	--	},

	--	config = function()
	--		-- some seful LSP commands
	--		vim.api.nvim_create_user_command("LspFormat", function()
	--			vim.lsp.buf.format()
	--		end, { desc = "Format buffer using LSP servers." })

	--		vim.api.nvim_create_user_command("LspRename", function()
	--			vim.lsp.buf.rename()
	--		end, { desc = "Rename symbol using LSP servers." })

	--		vim.api.nvim_create_user_command("LspHover", function()
	--			vim.lsp.buf.hover()
	--		end, { desc = "Show info at cursor using LSP." })

	--		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	--			pattern = "*",
	--			callback = require("nvim-lightbulb").update_lightbulb,
	--		})

	--		require("lsp_signature").setup({})

	--		require("symbols-outline").setup({
	--			relative_width = false,
	--			width = 30,
	--			symbol_blacklist = {
	--				"Variable",
	--			},
	--		})

	--		--require("neodev").setup({
	--		--	setup_jsonls = false,
	--		--	override = function(root_dir, library)
	--		--		-- enable it for all lua files
	--		--		library.enabled = true
	--		--		library.runtime = true
	--		--		library.types = true
	--		--		library.plugins = true
	--		--	end,
	--		--})

	--		--local lsp_zero = require("lsp-zero")

	--		--lsp_zero.set_preferences({
	--		--	suggest_lsp_servers = true,
	--		--	setup_servers_on_start = true,
	--		--	set_lsp_keymaps = false,
	--		--	configure_diagnostics = true,
	--		--	cmp_capabilities = true,
	--		--	manage_nvim_cmp = false,
	--		--	call_servers = "local",
	--		--	sign_icons = {
	--		--		error = "",
	--		--		warn = "",
	--		--		hint = "󰌵",
	--		--		info = "",
	--		--	},
	--		--})

	--		--lsp_zero.ensure_installed({
	--		--	"pyright",
	--		--	"clangd",
	--		--	"lua_ls",
	--		--	"rust_analyzer",
	--		--	"fortls",
	--		--	"ltex",
	--		--	"texlab",
	--		--	"bashls",
	--		--	"cmake",
	--		--	"yamlls",
	--		--})

	--		require("nvim-navic")
	--		--lsp_zero.on_attach(function(client, bufnr)
	--		--	if client.server_capabilities.documentSymbolProvider then
	--		--		-- attach navic if there's a suitable language server
	--		--		navic.attach(client, bufnr)
	--		--	end
	--		--end)

	--		--lsp_zero.setup()

	--		-- lsp_zero disables virtual text, reenable it
	--		vim.diagnostic.config({ virtual_text = true })
	--	end,
	--},
})

-- vim: noexpandtab tabstop=2 shiftwidth=2
