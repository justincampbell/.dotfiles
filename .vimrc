" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'Indent-Guides'
Bundle 'SuperTab'
Bundle 'Syntastic'
Bundle 'The-NERD-Commenter'
Bundle 'The-NERD-tree'
Bundle 'ack.vim'
Bundle 'ctrlp.vim'
Bundle 'fortes/vim-railscasts'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
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
colorscheme railscasts
syntax on

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
au BufNewFile,BufRead *.slim set filetype=ruby

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

