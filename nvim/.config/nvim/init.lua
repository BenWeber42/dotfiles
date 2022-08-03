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
opt.fillchars:append({ eob = " " })
-- show tabs and trailing spaces
opt.list = true
opt.listchars = { trail = "·", tab = "  ›" }
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
opt.wildmode = { "longest", "list" }
-- enable systemm clipboard
opt.clipboard:append("unnamedplus")
opt.updatetime = 500

-- my preferred diff options
opt.diffopt = { "internal", "closeoff" }

-- proper sign symbols:
vim.fn.sign_define(
	"DiagnosticSignError",
	{ texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "", numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" })

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
map_key("n", "<Leader>m", ":res<CR>", { noremap = true, silent = true })
-- back to equal window sizes
map_key("n", "<Leader>n", "<C-W>=", { noremap = true, silent = true })

-- edit nvim config
map_key("n", "<Leader>c", ":e ~/.config/nvim/init.lua<CR>", { noremap = true, silent = true })

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- copy over ssh with ansi control code
	use({
		"ojroques/nvim-osc52",

		config = function()
			local map_key = vim.keymap.set
			map_key("v", "<Leader>y", require("osc52").copy_visual, { noremap = true, silent = true })
		end,
	})

	-- stabilizes windows/cursors when new windows are opened
	use({
		"luukvbaal/stabilize.nvim",

		config = function()
			require("stabilize").setup()
		end,
	})

	-- automatic basic language support for many languages
	-- (provides more robust indentation than tree-sitter)
	-- NOTE: maybe only use regex based indentation for python?
	use("sheerun/vim-polyglot")

	-- proper grammar parsing
	use({
		"nvim-treesitter/nvim-treesitter",

		run = ":TSUpdate",

		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "cpp", "rust", "json", "bash", "lua" },
				highlight = {
					enable = true,
					-- enables traditional regex syntax highlighting needed by vim-polyglot indentation
					additional_vim_regex_highlighting = true,
				},
				-- vim-polyglot indentation is much more robust than tree-sitter currently
				indent = { enable = false },
			})
		end,
	})

	-- nordfox colorscheme
	use({
		"EdenEast/nightfox.nvim",

		run = function()
			local nightfox = require("nightfox")
			nightfox.init({ styles = { keywords = "italic" } })
			nightfox.compile()
		end,

		config = function()
			vim.cmd("colorscheme nordfox")
		end,
	})

	-- highlight word under curosr
	use({
		"RRethy/vim-illuminate",

		config = function()
			vim.g.Illuminate_delay = 500
		end,
	})

	-- colorize color codes
	use({
		"norcalli/nvim-colorizer.lua",

		config = function()
			require("colorizer").setup()
		end,
	})

	-- indentation lines
	use({
		"lukas-reineke/indent-blankline.nvim",

		config = function()
			require("indent_blankline").setup({
				char = "",
				show_trailing_blankline_indent = false,
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})

	-- git annotations
	use({
		"lewis6991/gitsigns.nvim",

		requires = "nvim-lua/plenary.nvim",

		config = function()
			require("gitsigns").setup()
		end,
	})

	-- git utilities
	use({ "tpope/vim-fugitive" })

	-- highlight TODO comments
	use({
		"folke/todo-comments.nvim",

		requires = "nvim-lua/plenary.nvim",

		config = function()
			require("todo-comments").setup({
				highlight = {
					pattern = [[<(KEYWORDS)>]],
					keyword = "bg",
				},
			})
		end,
	})

	-- status line
	use({
		"nvim-lualine/lualine.nvim",

		requires = "kyazdani42/nvim-web-devicons",

		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename", "filetype" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = { "diff" },
					lualine_z = { "encoding", "progress", "location" },
				},
			})
		end,
	})

	-- file tree
	use({
		"kyazdani42/nvim-tree.lua",

		requires = "kyazdani42/nvim-web-devicons",

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
			map_key("n", "<Leader>g", nvim_tree.find_file, { noremap = true, silent = true })
		end,
	})

	-- original fzf
	use({
		"junegunn/fzf",

		requires = "junegunn/fzf.vim",

		config = function()
			local map_key = vim.keymap.set
			--map_key('n', '<Leader>l', ":FzfBLines<CR>", { noremap = true, silent = true })
			map_key("n", "<Leader>f", ":FzfFiles<CR>", { noremap = true, silent = true })
			map_key("n", "<Leader>r", ":FzfRg<CR>", { noremap = true, silent = true })
			--map_key('n', '<Leader>h', ":FzfHelp<CR>", { noremap = true, silent = true })

			--let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
			--let g:fzf_command_prefix = 'Fzf'
			vim.g.fzf_layout = { window = { width = 0.9, height = 0.7 } }
			vim.g.fzf_command_prefix = "Fzf"
		end,
	})

	-- fzf commands in lua
	-- I'd like to completely migrate to fzf-lua, however, there's still some issues
	use({
		"ibhagwan/fzf-lua",

		requires = {
			"vijaymarupudi/nvim-fzf",
			"kyazdani42/nvim-web-devicons",
		},

		config = function()
			require("fzf-lua").setup({
				files = { multiprocess = false },
				blines = { show_unlisted = true },
			})

			local map_key = vim.keymap.set
			map_key("n", "<Leader>b", require("fzf-lua").builtin, { noremap = true, silent = true })
			map_key("n", "<Leader>l", require("fzf-lua").blines, { noremap = true, silent = true })
			-- has performance issues, using the old fzf plugin for this for now...
			-- map_key("n", "<Leader>f", require('fzf-lua').files, { noremap = true, silent = true })
			-- has performance issues, using the old fzf plugin for this for now...
			--map_key('n', '<Leader>r', require('fzf-lua').grep_project, { noremap = true, silent = true })
			map_key("n", "<Leader>h", require("fzf-lua").help_tags, { noremap = true, silent = true })
		end,
	})

	-- completion engine
	use({
		"hrsh7th/nvim-cmp",

		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "onsails/lspkind-nvim" },

			-- snippets
			{
				"saadparwaiz1/cmp_luasnip",
				requires = {
					{
						"L3MON4D3/LuaSnip",
						-- nice snippet collection
						requires = "rafamadriz/friendly-snippets",
						config = function()
							-- setup friendly-snippets
							require("luasnip.loaders.from_vscode").load({
								paths = {
									-- NOTE: isn't there a way to get the plugin path from packer?
									"~/.local/share/nvim/site/pack/packer/start/friendly-snippets/",
								},
							})
						end,
					},
				},
			},
		},

		config = function()
			local cmp = require("cmp")

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			local luasnip = require("luasnip")

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

			cmp.setup({

				snippet = {
					-- I don't want snippets, but nvim-cmp requires its...
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

				mapping = {

					["<Tab>"] = cmp.mapping(next_fun, { "i", "s" }),
					["<C-j>"] = cmp.mapping(next_fun, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(prev_fun, { "i", "s" }),
					["<C-k>"] = cmp.mapping(prev_fun, { "i", "s" }),

					["<CR>"] = cmp.mapping.confirm({ select = true }),
				},
				formatting = {
					format = require("lspkind").cmp_format({ maxwidth = 50 }),
				},
			})
		end,
	})

	-- LSP configurations
	use({
		"neovim/nvim-lspconfig",

		requires = {
			{ "ray-x/lsp_signature.nvim" },
			{
				"simrat39/symbols-outline.nvim",

				config = function()
					vim.g.symbols_outline = {
						relative_width = false,
						width = 30,
						symbol_blacklist = {
							"Variable",
						},
					}
				end,
			},
			{
				"kosayoda/nvim-lightbulb",
				config = function()
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						pattern = "*",
						callback = require("nvim-lightbulb").update_lightbulb,
					})
				end,
			},
			{
				"weilbith/nvim-code-action-menu",
				cmd = "CodeActionMenu",
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				requires = "nvim-lua/plenary.nvim",
			},
			{
				-- display diagnostics
				"folke/trouble.nvim",
				requires = "kyazdani42/nvim-web-devicons",
				config = function()
					require("trouble").setup({
						-- use "document_diagnostics" by default
						mode = "document_diagnostics",
						-- use my own defined signs
						use_diagnostic_signs = true,
					})
				end,
			},
		},

		-- is this really needed?
		after = "nvim-cmp",

		config = function()
			local lspconfig = require("lspconfig")

			local lsp_signature = require("lsp_signature")
			local illuminate = require("illuminate")

			local on_attach = function(client)
				lsp_signature.on_attach()
				illuminate.on_attach(client)
			end

			local capabilities =
				require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

			local default_lsp_settings = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			local lsp_settings = {
				pyright = {},
				clangd = {},
				sumneko_lua = {
					cmd = { "lua-language-server" },
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
								path = vim.split(package.path, ";"),
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					},
				},
				rust_analyzer = {},
				ltex = {},
				texlab = {},
			}

			for server_name, server_config in pairs(lsp_settings) do
				lspconfig[server_name].setup(vim.tbl_extend("keep", server_config, default_lsp_settings))
			end

			-- null-ls isn't supported by lspconfig
			local null_ls = require("null-ls")
			null_ls.setup(vim.tbl_extend("keep", {
				sources = {
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.stylua,
				},
			}, default_lsp_settings))

			vim.api.nvim_create_user_command("LspFormat", function()
				vim.lsp.buf.formatting_sync()
			end, { desc = "Format buffer using LSP servers." })

			vim.api.nvim_create_user_command("LspRename", function()
				vim.lsp.buf.rename()
			end, { desc = "Rename symbol using LSP servers." })
		end,
	})

	use({
		"williamboman/mason.nvim",

		requires = "williamboman/mason-lspconfig.nvim",
		-- FIXME: sequencing and dependencies are quite messy currently
		after = "nvim-lspconfig",

		config = function()
				require("mason").setup()
				require("mason-lspconfig").setup()
		end
	})


	-- integrated debugging
	use({
		-- FIXME: pretty messy in its current state
		"mfussenegger/nvim-dap",

		-- UI for debugging
		requires = {
			{
				"rcarriga/nvim-dap-ui",

				config = function()
					require("dapui").setup({
						layouts = {
							{
								size = 60,
								position = "left",
								elements = {
									{ id = "scopes", size = 0.7 },
									{ id = "stacks", size = 0.3 },
									{ id = "watches", size = 0.0 },
								},
							},
							{
								size = 60,
								position = "right",
								elements = {
									{ id = "repl", size = 0.7 },
									{ id = "breakpoints", size = 0.3 },
								},
							},
						},
					})
				end,
			},
			-- python configs
			{
				"mfussenegger/nvim-dap-python",

				config = function()
					local dap_python = require("dap-python")

					dap_python.setup(
						-- NOTE: isn't there a way to get the plugin path from packer?
						-- maybe use mason for debugpy instead?
						"~/.local/share/nvim/site/pack/packer/start/nvim-dap-python/debugpy-venv/bin/python"
					)

					dap_python.test_runner = "pytest"

					vim.api.nvim_create_user_command("DapPythonTestMethod", function()
						vim.cmd("tabnew +" .. vim.fn.line(".") .. " %")
						dap_python.test_method()
					end, { desc = "Debug method of python test." })
					vim.api.nvim_create_user_command(
						"DapPythonTestClass",
						dap_python.test_class,
						{ desc = "Debug class of python test." }
					)
					vim.api.nvim_create_user_command(
						"DapPythonDebugSelection",
						dap_python.debug_selection,
						{ desc = "Debug python selection." }
					)
				end,

				run = [[
					rm -rf debugpy-venv
					python -m venv debugpy-venv
					./debugpy-venv/bin/python -m pip install debugpy
				]],
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.fn.sign_define(
				"DapBreakpoint",
				{ texthl = "DiagnosticSignError", text = "ﭦ", numhl = "DiagnosticSignError" }
			)
		end,
	})
end)

-- vim: noexpandtab tabstop=2 shiftwidth=2
