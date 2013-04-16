" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'airblade/vim-gitgutter'
Bundle 'bbommarito/vim-slim'
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'ervandew/supertab'
Bundle 'fortes/vim-railscasts'
Bundle 'guns/vim-clojure-static'
Bundle 'kien/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'justincampbell/vim-eighties'
Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'mileszs/ack.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'vim-scripts/EvalSelection.vim'
Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-scripts/multvals.vim'
Bundle 'wikitopian/hardmode'
filetype plugin indent on

" Mouse
set mouse=a

" Automatically reload files
set autoread

" Set swap location
set directory=/tmp

" Colors
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
autocmd ColorScheme * highlight Visual ctermbg=236
colorscheme railscasts
syntax on

" Sign column
hi SignColumn ctermbg=0

" Line numbers
set number
set numberwidth=1

" Don't wrap text
set nowrap

" Backspace over anything
set backspace=eol,indent,start

" Soft tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Fancy characters
set listchars=tab:‣\	,trail:.,extends:⇢,precedes:⇠
set list

" Filetype syntax highlighting
au BufNewFile,BufRead *.jbuilder set filetype=ruby

" 80-column line
set colorcolumn=81
hi ColorColumn ctermbg=234

" Smart search
set incsearch
set ignorecase
set smartcase

" Clear search highlighting with enter
" noremap <CR> :nohlsearch<CR>/<BS>

" Smarter tab-completion
set wildmode=list:list,full

" Use Command-left/right to change buffer
noremap <D-left>  :bp<CR>
noremap <D-right> :bn<CR>

" Scroll before the cursor reaches the edge
set scrolloff=5

" Show leader keystrokes in the bottom right
set showcmd

" Indent-Guides
au VimEnter * :IndentGuidesEnable
let g:indent_guides_auto_colors = 0
hi IndentGuidesEven ctermbg=233
hi IndentGuidesOdd ctermbg=black

" NERDCommenter
let NERDRemoveExtraSpaces=1
let NERDSpaceDelims=1

map <leader>/ <plug>NERDCommenterToggle<CR>
imap <leader>/ <Esc><plug>NERDCommenterToggle<CR>i

" Gist
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1

" rainbow_parentheses.vim
au VimEnter *.clj RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
