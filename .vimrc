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
Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'mileszs/ack.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-rake'
Bundle 'vim-ruby/vim-ruby'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'vim-scripts/matchit.zip'
Bundle 'wikitopian/hardmode'
filetype plugin indent on

if has('gui_macvim')
  " MacVim
  set guioptions-=T " Hide toolbar
  set guioptions-=r " Hide scrollbars
  set gfn=Monaco:h16
else
  " Terminal
  set mouse=a
endif

" Automatically reload files
set autoread

" Set swap location
set directory=/tmp

" Colors
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
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
hi ColorColumn guibg=grey15

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
hi IndentGuidesEven ctermbg=233 guibg=#333333
hi IndentGuidesOdd ctermbg=black guibg=#2b2b2b

" NERDCommenter
let NERDRemoveExtraSpaces=1
let NERDSpaceDelims=1

map <leader>/ <plug>NERDCommenterToggle<CR>
imap <leader>/ <Esc><plug>NERDCommenterToggle<CR>i

if has("gui_macvim")
  map <D-/> <plug>NERDCommenterToggle<CR>
  imap <D-/> <Esc><plug>NERDCommenterToggle<CR>i
end

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
