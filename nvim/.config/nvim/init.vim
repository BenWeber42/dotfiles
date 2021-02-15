"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugins')

" colorize color codes
Plug 'norcalli/nvim-colorizer.lua'

" git functionality
Plug 'tpope/vim-fugitive'

" simple start screen
Plug 'mhinz/vim-startify'

" NERDTree
Plug 'scrooloose/nerdtree'
" NERDTree git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
" NERDTree syntax highlighting
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Luatree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Git annotations in the gutter
Plug 'airblade/vim-gitgutter'

" status line plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" color schemes plugin
Plug 'flazz/vim-colorschemes'
" sonokai
Plug 'sainnhe/sonokai'
" vim one
Plug 'rakr/vim-one'

" onebuddy
Plug 'tjdevries/colorbuddy.vim'
Plug 'Th3Whit3Wolf/onebuddy'

" A collection of language packs for Vim
Plug 'sheerun/vim-polyglot'

" treesitter syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" mlir support
Plug '~/mch/repos/llvm-project/mlir/utils/vim'

" show trailing white spaces
Plug 'ntpeters/vim-better-whitespace'

" Easily align text
Plug 'godlygeek/tabular'

" FZF
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" More FZF functionality
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/rpc' }

" Access coc lists through fzf
Plug 'antoinemadec/coc-fzf'

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim'

" indent lines for non-blank lines
Plug 'Yggdroot/indentLine'
" indent lines for blank lines
Plug 'lukas-reineke/indent-blankline.nvim'

" dev icons for many other plugins
Plug 'ryanoasis/vim-devicons'

" CoC IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" line numbers
set number
set relativenumber
" highlight current cursor line
set cursorline
set colorcolumn=80
set nowrap

" use system copy/paste
set clipboard+=unnamedplus
" enable mouse support
set mouse=a

" enable truecolor
set termguicolors
syntax on
set background=dark

"colorscheme codeschool

"let g:sonokai_style = 'atlantis'
"let g:sonokai_enable_italic = 1
"let g:sonokai_disable_italic_comment = 1
"colorscheme sonokai

let g:one_allow_italics = 1
colorscheme one

"lua require('colorbuddy').colorscheme('onebuddy')
"colorscheme onebuddy

"let g:oceanic_next_terminal_bold = 1
"let g:oceanic_next_terminal_italic = 1
"colorscheme OceanicNext

"hi Normal guifg=#dfdfdf
"hi VertSplit guifg=#9a9a9a
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
" update vim quicker (useful for gitgutter & coc.nvim)
set updatetime=300

" don't show preview menu dring completion
set completeopt=menu

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nmap yd :let @+ = expand("%:p").':'.line('.')<cr>

let mapleader = ' '
nmap <silent> <Leader>m :res<CR>
nnoremap <Leader>n <C-W>=


" terminal color palette
let g:terminal_color_0 = '#151515'
let g:terminal_color_1 = '#bc5653'
let g:terminal_color_2 = '#909d63'
let g:terminal_color_3 = '#ebc17a'
let g:terminal_color_4 = '#6a8799'
let g:terminal_color_5 = '#b06698'
let g:terminal_color_6 = '#c9dfff'
let g:terminal_color_7 = '#d9d9d9'
let g:terminal_color_8 = '#636363'
let g:terminal_color_9 = '#bc5653'
let g:terminal_color_10 = '#a0ac77'
let g:terminal_color_11 = '#ebc17a'
let g:terminal_color_12 = '#7eaac7'
let g:terminal_color_13 = '#b06698'
let g:terminal_color_14 = '#acbbd0'
let g:terminal_color_15 = '#f7f7f7'

" python providers:
" disable python 2
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" treesitter Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlighting & indentation
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  }
}
EOF

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autostart
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p
let NERDTreeIgnore = ['\.pyc$', '__pycache']
let NERDTreeMinimalUI=1
"nmap <silent> <Leader>g :NERDTreeFocus<CR>:wincmd p<CR>:NERDTreeFind<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Nvim Tree Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
"let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_ignore = [ '.git', 'node_modules', '__pycache__' ]
let g:nvim_tree_icons = { 'default': '' }
nmap <silent> <Leader>g :NvimTreeFindFile<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <Leader>l :FzfBLines<CR>
nmap <silent> <Leader>f :FzfFiles<CR>
nmap <silent> <Leader>r :FzfRg<CR>
nmap <silent> <Leader>h :FzfHelp<CR>
nmap <silent> <Leader>u :CocCommand fzf-preview.GitActions<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
let g:fzf_command_prefix = 'Fzf'

let g:fzf_vim_commands_list = [
  \   "jumpDefinition",
  \   "jumpDeclaration",
  \   "jumpImplementation",
  \   "jumpTypeDefinition",
  \   "jumpReferences",
  \   "doHover",
  \   "documentSymbols",
  \   "format",
  \   "codeAction",
  \   "codeLensAction",
  \   "highlight",
  \   "quickfixes",
  \   "diagnosticList",
  \   "rename",
  \   "workspaceSymbols"
  \ ]
function! s:handle_vim_command(command)
      call CocAction(a:command)
endfunction

command! -bang FzfVimCommands
  \   call fzf#run(fzf#wrap(
  \     "vim-commands",
  \     {"source": g:fzf_vim_commands_list, "sink": function('s:handle_vim_command')},
  \     <bang>0
  \   ))

nmap <silent> <Leader>c :FzfVimCommands<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'one'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git-Gutter Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_sign_added = '\ │'
let g:gitgutter_sign_modified = '\ │'
let g:gitgutter_sign_removed = '\ _'
let g:gitgutter_sign_removed_first_line = '\ _'
let g:gitgutter_sign_modified_removed = '\ _'
"highlight GitGutterAdd            guibg=#2a343a   guifg=green
"highlight GitGutterChange         guibg=#2a343a   guifg=orange
"highlight GitGutterDelete         guibg=#2a343a   guifg=red
"highlight GitGutterChangeDelete   guibg=#2a343a   guifg=red


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree-git-plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ "Modified"  : "",
  \ "Staged"    : "",
  \ "Untracked" : "",
  \ "Renamed"   : "",
  \ "Unmerged"  : "",
  \ "Deleted"   : "",
  \ "Dirty"     : "",
  \ "Clean"     : "",
  \ 'Ignored'   : '',
  \ "Unknown"   : ""
\ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Whitespace Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace guibg=red

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vista Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:vista_default_executive = 'coc'
" how to do auto start?
" autocmd VimEnter * Vista
" autocmd VimEnter * wincmd p
"nmap <silent> <Leader>v :Vista!!<CR>
nmap <silent> <Leader>o :Vista finder coc<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vista Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:LanguageClient_serverCommands = {
"    \ 'python': ['pyls']
"    \ }

"nmap <silent> <Leader>c :call LanguageClient_contextMenu()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CoC Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" required by coc.nvim
set hidden
set nobackup
set nowritebackup
set shortmess+=c
" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"" coc bindings
"" nmap <silent> <Leader>d <Plug>(coc-definition)
"" nmap <silent> <Leader>e <Plug>(coc-declaration)
"" nmap <silent> <Leader>i <Plug>(coc-implementation)
"" nmap <silent> <Leader>t <Plug>(coc-type-definition)
"" nmap <silent> <Leader>r <Plug>(coc-references)
"" nmap <silent> <Leader>l :CocList symbols<Cr>
"" nmap <silent> <Leader>o :CocList -A outline<Cr>
"" nmap <silent> <Leader>w :CocList -A diagnostics<Cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent line settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_char = ''

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorizer settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require'colorizer'.setup()
