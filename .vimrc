if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" <C-j>   Move current line/selection down
" <C-k>   Move current line/selection up
" <s> key toggles searches

" Color scheme
" Leader-w to interactive work with windows
" Plug 'Townk/vim-autoclose'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'godlygeek/tabular'
" Plug 'hecal3/vim-leader-guide'
" Plug 'tpope/vim-surround'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
Plug 'sbdchd/neoformat'
Plug 'ap/vim-buftabline'
Plug 'matze/vim-move'
Plug 'morhetz/gruvbox'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-commentary'

call plug#end()

let loaded_matchparen = 1

colorscheme gruvbox
set background=dark

let g:sneak#streak = 1

set hidden
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>
" Use ctrl with move plugin
let g:move_key_modifier = 'C'


au BufRead .vimrc set nospell
" Auto reload vimrc once updated
augroup reload_vimrc
    autocmd!
    autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" Auto open VimExplorer if no file to open was given
if !has("gui_vimr")
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * if argc() == 0 | Vexplore! | endif
augroup END
endif

" force markdown syntax for .md files
augroup markdown
    " remove previous autocmds
    autocmd!
    " set every new or read *.md buffer to use the markdown filetype 
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown 
    autocmd Filetype markdown setlocal wrap
    autocmd Filetype markdown setlocal linebreak
    autocmd Filetype markdown setlocal nolist
augroup END
set showtabline=0   " never show tabline

set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Green

set spell spelllang=ru_yo,en_us

" NerdTree style for explorer mode 
let g:netrw_liststyle=3
let g:netrw_winsize = -30
let g:netrw_browse_split = 4
let g:netrw_banner = 0

filetype indent on      " activates indenting for files
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

if bufwinnr(1)
	map + <C-W>+
	map - <C-W>-
endif
set wildmenu
set mouse=a
set autoindent          " auto-indent
set clipboard=unnamed	" Use the OS clipboard by default (on versions compiled with `+clipboard`)
" set cursorline		" Highlight current line
set encoding=utf-8 nobomb " Use UTF-8 without BOM
set hlsearch	 	" Highlight searches
set ignorecase          " Make searches case-insensitive.
set incsearch 		" Show the cursor position
set laststatus=2	" Always show statusbar (for Airline)
set modeline      	" Respect modeline in files
set modelines=4
set nocompatible       	" get rid of Vi compatibility mode. SET FIRST!
set nowrap              " don't wrap text
set number              " show line numbers
set ruler               " Always show info along bottom.
set scrolloff=3		" Start scrolling three lines before the horizontal window border
set shiftround          " always indent/outdent to the nearest tabstop
set shortmess=atI 	" Don’t show the intro message when starting Vim
set showcmd		" Show the (partial) command as it’s being typed
set smarttab            " use tabs at the start of a line, spaces elsewhere
" set t_Co=256            " enable 256-color mode.
set title 		" Show the filename in the window titlebar
set ttyfast 		" Optimize for fast terminal connections
set wildmenu		" Enhance command-line completion
syntax enable           " enable syntax highlighting (previously syntax on).

