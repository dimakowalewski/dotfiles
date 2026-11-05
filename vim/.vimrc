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
set termguicolors           " true color, needed by the Catppuccin themes

" Theme: Catppuccin, following the macOS light/dark appearance (same as Zed).
" Flavors in ~/.vim/colors: catppuccin_latte, _frappe, _macchiato, _mocha
let g:theme_light = 'catppuccin_latte'
let g:theme_dark  = 'catppuccin_mocha'

let s:is_dark = -1
function! s:SetAppearance(dark) abort
  if a:dark == s:is_dark | return | endif   " only act on an actual change
  let s:is_dark = a:dark
  execute 'silent! colorscheme' (a:dark ? g:theme_dark : g:theme_light)
endfunction

" `defaults read -g AppleInterfaceStyle` exits 0 (prints "Dark") in dark mode
" and fails in light mode, so the exit code is all we need.
function! s:OnAppearanceExit(job, status) abort
  call s:SetAppearance(a:status == 0)
endfunction

function! s:CheckAppearance(...) abort
  call job_start(['defaults', 'read', '-g', 'AppleInterfaceStyle'],
        \ {'exit_cb': function('s:OnAppearanceExit'),
        \  'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
endfunction

if executable('defaults')
  " Check once at startup (synchronously, so there's no flash of the wrong theme),
  " then poll in the background and on focus so Vim follows a switch live.
  call system('defaults read -g AppleInterfaceStyle')
  call s:SetAppearance(v:shell_error == 0)
  if has('timers') && has('job')
    call timer_start(3000, function('s:CheckAppearance'), {'repeat': -1})
    augroup follow_appearance
      autocmd!
      autocmd FocusGained * call s:CheckAppearance()
    augroup END
  endif
else
  call s:SetAppearance(1)
endif

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
