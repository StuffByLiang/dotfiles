" ---- Basics ----
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set number relativenumber
set cursorline
set showcmd
set wildmenu
set laststatus=2
set scrolloff=5
set mouse=a
set backspace=indent,eol,start
set hidden
set updatetime=300
set clipboard=unnamed          " use macOS clipboard

" ---- Indentation ----
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set autoindent smartindent

" ---- Search ----
set incsearch hlsearch
set ignorecase smartcase

" ---- Files ----
set noswapfile
set undofile
set undodir=~/.vim/undo//

" ---- Keys ----
let mapleader = " "
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
inoremap jk <Esc>
inoremap kj <Esc>
" move between splits with ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ---- Plugins (vim-plug, auto-installs on first launch) ----
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'      " gcc to toggle comment
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'        " :Git
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'  " ctrl+hjkl across vim + tmux panes
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug '/opt/homebrew/opt/fzf'      " fzf binary from Homebrew
Plug 'junegunn/fzf.vim'           " <leader>f files, <leader>/ ripgrep, <leader>b buffers
call plug#end()

set noshowmode
set termguicolors
silent! colorscheme gruvbox
set background=dark
let g:lightline = { 'colorscheme': 'gruvbox' }

nnoremap <leader>f :Files<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>b :Buffers<CR>
