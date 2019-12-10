set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
" execute 'source' fnamemodify(expand('<sfile>'), ':h').'/vimrc'
" if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
" 	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

" " call plug#begin('~/.vim/plugged')
" call plug#begin()
" " Color scheme
" Plug 'morhetz/gruvbox'
" call plug#end()

" " For Neovim 0.1.3 and 0.1.4
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" " Or if you have Neovim >= 0.1.5
" if (has("termguicolors"))
"  set termguicolors
" endif

" " Theme
" syntax enable
" colorscheme gruvbox

