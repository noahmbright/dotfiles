syntax on
filetype plugin indent on
colorscheme habamax
set noswapfile
set relativenumber
set number
let mapleader = " "

"""""""""""" STATUS LINE """"""""""""
set laststatus=2
set statusline = ""
set statusline+=%f
set statusline+=\ %m

"""""""""""" SEARCH """"""""""""
noremap n nzz
noremap N Nzz

"""""""""""" NETRW """"""""""""
noremap <Leader>pv :Ex<CR>

"""""""""""" WINDOWS """"""""""""
" all CTRL-W normal mode commands can be executed with :wincmd

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" By default, C-p moves the cursor up one line. 
" Remap to move the cursor to the previous split
noremap <C-p> <C-w>p

noremap <Leader>sx <C-w>q
noremap <Leader>sh <C-w>v
noremap <Leader>sv <C-w>n

" Remap shift-arrow keys to resize windows


" NOTE I like the idea of the CTRL-HJKL commands
" 	they move a split all the way up/down/right/left


"""""""""""" AUTOCOMMANDS """"""""""""

" open help windows in a vertical split on the right side of the screen
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END
