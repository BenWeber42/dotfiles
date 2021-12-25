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
opt.colorcolumn = '80'
-- line numbers
opt.number = true
opt.relativenumber = true
-- remove the weird `~` at the end of buffers
opt.fillchars:append({ eob = ' ' })
-- show trailing spaces
opt.list = true
opt.listchars = { trail = "·" }
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

-- proper sign symbols:
-- For some reason nightfox breaks `LspDiagnosticsSignError`,
-- but it defines `LspDiagnosticsError`, so we use that instead...
vim.fn.sign_define(
  "DiagnosticSignError",
  { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  { texthl = "DiagnosticSignWarn", text = "", numhl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo",
  { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" }
)

-------------------------------------------------------------------------------
-- Vim Key bindings
-------------------------------------------------------------------------------
local map_key = vim.api.nvim_set_keymap
vim.g.mapleader = ' '

-- easy window navigation
map_key('n', '<C-J>', '<C-W><C-J>', { noremap = true, silent = true })
map_key('n', '<C-K>', '<C-W><C-K>', { noremap = true, silent = true })
map_key('n', '<C-L>', '<C-W><C-L>', { noremap = true, silent = true })
map_key('n', '<C-H>', '<C-W><C-H>', { noremap = true, silent = true })
-- maximixe window
map_key('n', '<Leader>m', ':res<CR>', { noremap = true, silent = true })
-- back to equal window sizes
map_key('n', '<Leader>n', '<C-W>=', { noremap = true, silent = true })

-- edit nvim config
map_key('n', '<Leader>c', ':e ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require("packer").startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    "luukvbaal/stabilize.nvim",

    config = function()
      require("stabilize").setup()
    end
  }

    -- proper grammar parsing
  use {
    'nvim-treesitter/nvim-treesitter',

    run = ':TSUpdate',

    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "cpp", "rust", "json", "bash", "lua" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }


  -- nordfox colorscheme
  use {
    'EdenEast/nightfox.nvim',

    config = function()
      local nightfox = require('nightfox')

      nightfox.setup({
        fox = "nordfox", -- style
        styles = {
          keywords = "italic",
        },
      })

      nightfox.load()
    end
  }


  -- colorize color codes
  use {
    'norcalli/nvim-colorizer.lua',

    config = function()
      require('colorizer').setup()
    end
  }


  -- indentation lines
  use {
    "lukas-reineke/indent-blankline.nvim",

    config = function()
      require("indent_blankline").setup({
        char = "",
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_current_context_start = true,
      })
    end
  }


  -- git annotations
  use {
    'lewis6991/gitsigns.nvim',

    requires = 'nvim-lua/plenary.nvim',

    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    "folke/todo-comments.nvim",

    requires = "nvim-lua/plenary.nvim",

    config = function()
      require("todo-comments").setup({})
    end
  }


  -- status line
  use {
    'nvim-lualine/lualine.nvim',

    requires = 'kyazdani42/nvim-web-devicons',

    config = function()
      require("lualine").setup({
        options = {
          theme = "ayu_mirage",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {"NvimTree"},
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"filename", "filetype"},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {"diff"},
          lualine_z = {"encoding", "progress", "location"},
        },
      })
    end
  }


  -- file tree
  use {
    'kyazdani42/nvim-tree.lua',

    requires = 'kyazdani42/nvim-web-devicons',

    config = function()
      -- nvim tree requires some config still through vim script:
      vim.cmd [[
        let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
        let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
        let g:nvim_tree_icons = { 'default': '' }
        " work-around to have NvimTree auto start
        autocmd VimEnter * NvimTreeOpen
        autocmd VimEnter * wincmd p
      ]]
      require('nvim-tree').setup({
        -- doesn't do what we want
        --open_on_setup = true,
        auto_close = true,
      })
      local map_key = vim.api.nvim_set_keymap
      map_key('n', '<Leader>g', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
    end
  }


  -- original fzf
  use {
    'junegunn/fzf',

    requires = 'junegunn/fzf.vim',

    config = function()
      local map_key = vim.api.nvim_set_keymap
      --map_key('n', '<Leader>l', ":FzfBLines<CR>", { noremap = true, silent = true })
      --map_key('n', '<Leader>f', ":FzfFiles<CR>", { noremap = true, silent = true })
      map_key('n', '<Leader>r', ":FzfRg<CR>", { noremap = true, silent = true })
      --map_key('n', '<Leader>h', ":FzfHelp<CR>", { noremap = true, silent = true })

      --let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
      --let g:fzf_command_prefix = 'Fzf'
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.7 } }
      vim.g.fzf_command_prefix = 'Fzf'
    end
  }


  -- fzf commands in lua
  -- I'd like to completely migrate to fzf-lua, however, there's still some issues
  use {
    'ibhagwan/fzf-lua',

    requires = {
      'vijaymarupudi/nvim-fzf',
      'kyazdani42/nvim-web-devicons',
    },

    config = function()
      local map_key = vim.api.nvim_set_keymap
      map_key('n', '<Leader>b', "<cmd>lua require('fzf-lua').builtin()<CR>", { noremap = true, silent = true })
      map_key('n', '<Leader>l', "<cmd>lua require('fzf-lua').blines({ show_unlisted=true })<CR>", { noremap = true, silent = true })
      map_key('n', '<Leader>f', "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true, silent = true })
      -- has performance issues, using the old fzf plugin for this for now...
      --map_key('n', '<Leader>r', "<cmd>lua require('fzf-lua').grep_project()<CR>", { noremap = true, silent = true })
      map_key('n', '<Leader>h', "<cmd>lua require('fzf-lua').help_tags()<CR>", { noremap = true, silent = true })
    end
  }

  -- completion engine
  use {
    'hrsh7th/nvim-cmp',

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
              require("luasnip.loaders.from_vscode").load({ paths = {
                -- NOTE: isn't there a way to get the plugin path from packer?
                "~/.local/share/nvim/site/pack/packer/start/friendly-snippets/"
              }})
            end
          },
        },
      },
    },

    config = function()
      local cmp = require("cmp")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      local luasnip = require("luasnip")

      cmp.setup({

        snippet = {
          -- I don't want snippets, but nvim-cmp requires its...
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        }),

        mapping = {

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        formatting = {
          format = require('lspkind').cmp_format({ maxwidth = 50 })
        }
      })
    end
  }

  -- LSP configurations
  use {
    "neovim/nvim-lspconfig",

    requires = {
      { "ray-x/lsp_signature.nvim" },
      { "simrat39/symbols-outline.nvim" },
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.cmd [[
            autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
          ]]
        end
      },
      {
        -- currently broken, switch back to upstream when fix is merged
        --'weilbith/nvim-code-action-menu',
        'filtsin/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
      }
    },

    -- is this really needed?
    after = "nvim-cmp",

    config = function()
      local lspconfig = require("lspconfig")

      local lsp_signature = require("lsp_signature")
      local on_attach = function(_, _)
        lsp_signature.on_attach()
      end

      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local servers = {
        pyright = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        clangd = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
        sumneko_lua = {
          cmd = { "lua-language-server" },
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
          on_attach = on_attach,
          capabilities = capabilities,
        },
        rust_analyzer = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      }

      for server_name, server_config in pairs(servers) do
        lspconfig[server_name].setup(server_config)
      end

    end,
  }

end)
