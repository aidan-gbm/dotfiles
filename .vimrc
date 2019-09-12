" VIMRC

" Syntax
syntax on
set number
set t_Co=256
set background=dark
colorscheme elflord

" Markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

" Setup
set laststatus=2
set nocompatible
set novisualbell
set ttyfast
set wrap

" Tabs & Whitespace
set tabstop=2
set softtabstop=2
set noexpandtab
set smarttab

" Indenting
set autoindent
set smartindent
set shiftwidth=2
