" Basics
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set hidden                  " switch buffers without saving first
set mouse=a                 " mouse support
set clipboard=unnamed       " yank to the macOS clipboard

" Look
set number
set cursorline
set showcmd
set laststatus=2            " always show the status line
set scrolloff=8             " keep context around the cursor
set signcolumn=yes
set background=light         " change to light if needed
set termguicolors           " true color, matches your Ghostty theme better

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase               " case-sensitive only if you type capitals
nnoremap <Esc><Esc> :nohlsearch<CR>

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent

" Files
set undofile                " persistent undo
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
set autoread

" Completion and navigation
set wildmenu
set wildmode=longest:full,full
set path+=**                " :find searches subfolders

" Cursor shape: bar in insert, block in normal (works in Ghostty)
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Leader key and a few mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>f :find

" Search with ripgrep inside Vim
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m
nnoremap <leader>/ :silent grep<Space>

" fzf file picker, since fzf was installed with Homebrew
set rtp+=/opt/homebrew/opt/fzf
nnoremap <leader>p :FZF<CR>
