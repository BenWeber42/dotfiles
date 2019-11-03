"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugins')

" allow .lvimrc for local project settings
Plug 'embear/vim-localvimrc'

" NERDTree
Plug 'scrooloose/nerdtree'

" fuzzy finder
" Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

" NERDTree git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git annotations in the gutter
Plug 'airblade/vim-gitgutter'

" status line plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" color schemes plugin
Plug 'flazz/vim-colorschemes'

" visualize indentation
"Plug 'nathanaelkane/vim-indent-guides'

" visualize indentation
"Plug 'Yggdroot/indentLine'

" show trailing white spaces
Plug 'ntpeters/vim-better-whitespace'

" Easily align text
Plug 'godlygeek/tabular'

" Language Server Protocol Client
" Plug 'autozimu/LanguageClient-neovim', {
" \ 'branch': 'next',
" \ 'do': 'bash install.sh'
" \ }

" neovim completion manager
" Plug 'roxma/nvim-completion-manager'

" coc completer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim'

" dev icons for many other plugins
Plug 'ryanoasis/vim-devicons'

" typescript syntax highlighting
" Plug 'leafgarland/typescript-vim'

" All of your Plugins must be added before the following line
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on
" be iMproved
set nocompatible
set encoding=utf8

" only execute files I own
set secure
set modelines=0
" tabs
set shiftwidth=2
set tabstop=2
set softtabstop=2
"set autoindent
"set smartindent
" replace tabs with spaces
set expandtab
" required by LanguageClient for rename
set hidden
" don't give |ins-completion-menu| messages.  For nvim-completion-manager
set shortmess+=c

" line numbers
set number
set relativenumber
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" highlight current cursor line
set cursorline
set colorcolumn=80

" use system copy/paste
set clipboard+=unnamedplus
" enable mouse support
set mouse=a

" enable truecolor
set termguicolors
syntax on
set background=dark
colorscheme codeschool
hi Normal guifg=#dfdfdf
hi VertSplit guifg=#9a9a9a
set fillchars=eob:\ 

" bash like tab completion
set wildmode=longest,list

" smartcase for search
set ignorecase " needed to make smartcase work
set smartcase
set incsearch " start searching while typing
set hlsearch
set gdefault " replace all occurences on the same line by default (s/ command)

" set lazyredraw " activate if scrolling is laggy
set ttyfast

" don't show preview menu dring completion
set completeopt=menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autostart
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
let NERDTreeIgnore = ['\.pyc$', '__pycache']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lvimrc Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't ask before loading .lvimrc
let g:localvimrc_ask = 0
let g:localvimrc_sandbox = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent Guides Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_guide_size = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:indentLine_char = '▏'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'molokai'
let g:airline_powerline_fonts = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git-Gutter Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" update every 250ms (default 4s)
" set updatetime=250
" autocmd VimEnter * GitGutterDisable

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" denite Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
"call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
"call denite#custom#source('line', 'matchers', ['matcher_fuzzy'])
"call denite#custom#var('file_rec', 'command', ['ag', '--nocolor', '--nogroup', '-g', ''])
"nnoremap <c-p> :Denite file_rec tag line<cr>
"nnoremap <c-h> :Denite help<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Whitespace Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace guibg=red

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ale Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Fixes visual mode bug: https://github.com/w0rp/ale/issues/272
" " let g:ale_lint_on_enter = 0
" " let g:ale_lint_on_save = 0

" let g:ale_sign_column_always = 1
" " let g:ale_change_sign_column_color = 1 " requires better highlighting
" "let g:ale_set_quickfix = 1
" "let g:ale_open_list = 1
" " let g:ale_sign_error = '✗'
" let g:ale_sign_error = '⚠'
" let g:ale_sign_warning = '⚠'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_save = 1 " FIXME: semms to be broken sometimes
" " TODO: info sign (& others)
" let g:ale_echo_msg_format = '[%linter%] (%severity%): %s'
" highlight ALEErrorSign gui=bold guifg=#FF4D4D guibg=#2a343a
" highlight ALEError guifg=#FF4D4D
" highlight ALEWarningSign gui=bold guifg=orange guibg=#2a343a
" highlight ALEWarning guifg=orange

" " disable pylint for python files
" let g:ale_linters = {
" \   'python': ['flake8', 'mypy']
" \}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" deoplete Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:deoplete#enable_at_startup = 1
" " deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" " start completion at first character for all ('_') sources
" call deoplete#custom#set('_', 'min_pattern_length', 1)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gutentags Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " tags will only be generated for directories with a .ctags config file
" let g:gutentags_add_default_project_roots = 0
" let g:gutentags_project_root = ['.ctags']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'highlight TagbarVisibilityProtected guifg=#3C98D8
" let g:tagbar_sort = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LanguageClient Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:LanguageClient_serverCommands = {}
"let g:LanguageClient_serverCommands.javascript = ['javascript-typescript-stdio']
"let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']
"nnoremap <silent> <C-]> :call LanguageClient_textDocument_definition()<CR>
"com Re call LanguageClient_textDocument_rename()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vista Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vista_default_executive = 'coc'
" how to do auto start?
" autocmd VimEnter * Vista
" autocmd VimEnter * wincmd p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CoC Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nvim-Completion-Manager Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enter during completion creates new line
"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Use <TAB> to select the popup menu:
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"let g:cm_matcher = {}
"let g:cm_matcher.module = 'cm_matchers.fuzzy_matcher'
