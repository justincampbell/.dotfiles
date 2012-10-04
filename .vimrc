" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'ack.vim'
Bundle 'fugitive.vim'
Bundle 'Indent-Guides'
Bundle 'Railscasts-Theme-GUIand256color'
Bundle 'SuperTab'
Bundle 'Syntastic'
Bundle 'The-NERD-Commenter'
Bundle 'The-NERD-tree'
filetype plugin indent on

if has('gui_macvim')
  " MacVim
  set guioptions-=T " Hide toolbar
  set guioptions-=r " Hide scrollbars
  set gfn=Monaco:h18
else
  " Terminal
  set mouse=a
endif

" Automatically reload files
set autoread

" Font and colors
colorscheme railscasts
syntax on

" Filetype syntax highlighting
au BufNewFile,BufRead *.jbuilder set filetype=ruby
au BufNewFile,BufRead *.slim set filetype=ruby

" 80-column line
set colorcolumn=81
hi ColorColumn ctermbg=234
hi ColorColumn guibg=grey15

" Clear search highlighting with enter
noremap <CR> :nohlsearch<CR>/<BS>

" Use Command-left/right to change buffer
noremap <D-left>  :bp<CR>
noremap <D-right> :bn<CR>

" Enable vim-indent-guides plugin
au VimEnter * :IndentGuidesEnable
let g:indent_guides_auto_colors = 0
hi IndentGuidesEven ctermbg=233 guibg=#333333
hi IndentGuidesOdd ctermbg=black guibg=#2b2b2b

" Scroll before the cursor reaches the edge
set scrolloff=5

" Show leader keystrokes in the bottom right
set showcmd

