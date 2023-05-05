set nocompatible
filetype off

" OTHER SETTINGS
set splitbelow
set splitright
set backspace=indent,eol,start
" use ctl+<vim directional key> to navigate split screens
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" use space key to fold code
nnoremap <space> za
set foldmethod=indent
set foldlevel=99
let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set shiftwidth=4 |
    \ set softtabstop=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
au BufNewFile,BufRead *.jaws
    \ set syntax=whitespace

set encoding=utf-8
let g:ycm_autoclose_preview_window_after_completion=1
let python_highlight_all=1
syntax on
let NERDTreeIgnore=['\.pyc$', '\~$']
set number
set clipboard=unnamed
set showmatch
set laststatus=2
" set vim colors for Windows Terminal
set t_Co=256
set t_ut=""
set background=dark
colors lawndoc

:set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

