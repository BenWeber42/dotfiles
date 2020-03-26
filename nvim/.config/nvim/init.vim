"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.local/share/nvim/plugins')

" NERDTree
Plug 'scrooloose/nerdtree'

" NERDTree git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git annotations in the gutter
Plug 'airblade/vim-gitgutter'

" status line plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" color schemes plugin
Plug 'flazz/vim-colorschemes'

" A collection of language packs for Vim
Plug 'sheerun/vim-polyglot'

" show trailing white spaces
Plug 'ntpeters/vim-better-whitespace'

" Easily align text
Plug 'godlygeek/tabular'

" coc completer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" gutentags
Plug 'ludovicchabant/vim-gutentags'

" FZF
Plug 'junegunn/fzf.vim'

" Viewer & Finder for LSP symbols and tags in Vim
Plug 'liuchengxu/vista.vim'

" dev icons for many other plugins
Plug 'ryanoasis/vim-devicons'

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

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nmap yd :let @+ = expand("%:p").':'.line('.')<cr>

let mapleader = ','
nmap <silent> <Leader>m :res<CR>
nnoremap <Leader>n <C-W>=

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
let NERDTreeMinimalUI=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <Leader>l :FzfBLines<CR>
nmap <silent> <Leader>t :FzfTags<CR>
nmap <silent> <Leader>f :FzfFiles<CR>
nmap <silent> <Leader>r :FzfRg<CR>
nmap <silent> <Leader>h :FzfHelp<CR>

let g:fzf_layout = { 'up': '~40%' }
let g:fzf_command_prefix = 'Fzf'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_theme = 'molokai'
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
highlight GitGutterAdd            guibg=#2a343a   guifg=green
highlight GitGutterChange         guibg=#2a343a   guifg=orange
highlight GitGutterDelete         guibg=#2a343a   guifg=red
highlight GitGutterChangeDelete   guibg=#2a343a   guifg=red


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree-git-plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeIndicatorMapCustom = {
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
" let g:vista_default_executive = 'coc'
let g:vista_echo_cursor_strategy = 'floating_win'
" how to do auto start?
" autocmd VimEnter * Vista
" autocmd VimEnter * wincmd p
nmap <silent> <Leader>v :Vista!!<CR>
nmap <silent> <Leader>o :Vista finder<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CoC Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" required by coc.nvim
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
"set signcolumn=yes
" Use <Tab> and <S-Tab> to navigate the completion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" coc bindings
" nmap <silent> <Leader>d <Plug>(coc-definition)
" nmap <silent> <Leader>e <Plug>(coc-declaration)
" nmap <silent> <Leader>i <Plug>(coc-implementation)
" nmap <silent> <Leader>t <Plug>(coc-type-definition)
" nmap <silent> <Leader>r <Plug>(coc-references)
" nmap <silent> <Leader>l :CocList symbols<Cr>
" nmap <silent> <Leader>o :CocList -A outline<Cr>
" nmap <silent> <Leader>w :CocList -A diagnostics<Cr>
