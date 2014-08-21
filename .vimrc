set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'beloglazov/vim-online-thesaurus'
Plugin 'bling/vim-airline'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'ivyl/vim-bling'
Plugin 'justincampbell/vim-eighties'
Plugin 'justincampbell/vim-railscasts'
Plugin 'kien/ctrlp.vim'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'mileszs/ack.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-scripts/multvals.vim'
Plugin 'wikitopian/hardmode'

" Clojure
Plugin 'guns/vim-clojure-static'
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-classpath'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'

" CoffeeScript
Plugin 'kchmck/vim-coffee-script'

" Docker
Plugin 'ekalinin/Dockerfile.vim'

" Elixir
Plugin 'elixir-lang/vim-elixir'

" Go
Plugin 'fatih/vim-go'

" Haskell
Plugin 'dag/vim2hs'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'shougo/vimproc.vim'

" JavaScript
Plugin 'pangloss/vim-javascript'

" Markdown
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'tpope/vim-markdown'

" Ruby
Plugin 'ecomba/vim-ruby-refactoring'
Plugin 'hwartig/vim-seeing-is-believing'
Plugin 'jgdavey/vim-blockle'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'vim-ruby/vim-ruby'

" Scala
Plugin 'derekwyatt/vim-scala'

" Shell
Plugin 'markcornick/vim-bats'
Plugin 'rosstimson/bats.vim'

" Slim
Plugin 'slim-template/vim-slim'

call vundle#end()

filetype plugin indent on

" Mouse
set mouse=a

" Automatically reload files
set autoread

" Lazily redraw screen
set lazyredraw

" Set swap location
set directory=/tmp

" Colors
autocmd ColorScheme * highlight Visual ctermbg=236
colorscheme railscasts
syntax on
highlight! link Conceal Keyword

" Sign and number columns
highlight SignColumn ctermbg=0
highlight NonText ctermbg=0 ctermfg=0
highlight Vertsplit ctermbg=233 ctermfg=233

" Tabs
highlight! link TabLineFill CursorColumn
highlight TabLine ctermfg=7 ctermbg=234 cterm=none
highlight TabLineSel ctermfg=166 ctermbg=234
map <Tab> :tabn<cr>
map <S-Tab> :tabp<cr>

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
set tabstop=4

" Fancy characters
set listchars=tab:‣\ ,trail:·,extends:⇢,precedes:⇠
set list

" Highlight trailing whitespace
highlight! link ExtraWhitespace Todo
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufWinLeave * call clearmatches()

" Filetype mappings
autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
autocmd BufNewFile,BufRead *.skim set filetype=slim
autocmd BufNewFile,BufRead *.md,*.markdown set filetype=markdown

" Filetype-specific settings
autocmd FileType gitcommit,markdown set spell
autocmd FileType markdown set wrap
autocmd FileType "" set wrap
autocmd FileType haskell set shiftwidth=4
autocmd FileType haskell nnoremap <Leader>hc :GhcModCheckAsync<cr>
autocmd FileType haskell nnoremap <Leader>ht :GhcModType<cr>

" 80-column line
set colorcolumn=81
highlight! link ColorColumn CursorColumn

" Smart search
set incsearch
set ignorecase
set smartcase

" Smarter tab-completion
set wildmode=list:list,full

" Smarter split opening
set splitbelow
set splitright

" Scroll before the cursor reaches the edge
set scrolloff=5

" Show leader keystrokes in the bottom right
set showcmd

" Extra leader mappings
nmap , \

" Always show filename
set laststatus=2

" Indent-Guides
autocmd VimEnter * :IndentGuidesEnable
let g:indent_guides_auto_colors = 0
highlight IndentGuidesEven ctermbg=233
highlight IndentGuidesOdd ctermbg=black

" NERDCommenter
let NERDRemoveExtraSpaces=1
let NERDSpaceDelims=1

map <leader>/ <plug>NERDCommenterToggle<CR>

" Gist
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1

" rainbow_parentheses.vim
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces
let g:rbpt_colorpairs = [
      \ ['brown',       'RoyalBlue3'],
      \ ['Darkblue',    'SeaGreen3'],
      \ ['darkgreen',   'firebrick3'],
      \ ['darkcyan',    'RoyalBlue3'],
      \ ['darkred',     'SeaGreen3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['brown',       'firebrick3'],
      \ ['darkmagenta', 'DarkOrchid3'],
      \ ['Darkblue',    'firebrick3'],
      \ ['darkgreen',   'RoyalBlue3'],
      \ ['darkcyan',    'SeaGreen3'],
      \ ['darkred',     'DarkOrchid3'],
      \ ['red',         'firebrick3'],
      \ ]
let g:rbpt_max = len(g:rbpt_colorpairs)

" seeing-is-beleiving
map <F4> <Plug>(seeing-is-believing-mark)
imap <F4> <Plug>(seeing-is-believing-mark)
map <F5> <Plug>(seeing-is-believing-run)
imap <F5> <Plug>(seeing-is-believing-run)

" alias common mistyped commands to correct command
cabbrev E e
cabbrev Q q
cabbrev W w
cabbrev Wq wq

" The Silver Searcher
let g:ag_binary = system("which ag | xargs echo -n")
if filereadable(g:ag_binary)
  let g:ackprg = g:ag_binary . ' --nocolor --nogroup --column'
  let g:ctrlp_user_command = g:ag_binary . ' %s -l --nocolor -g ""'
endif

" vim-airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_a='' " mode
let g:airline_section_b='' " branch
let g:airline_section_z='' " ruler
let g:airline_theme='monochrome'

" Sort
vnoremap <Leader>s :sort<cr>

" Macro repeat
nnoremap <Space> @q

" Insert debuggers
nnoremap <Leader>d Orequire 'debugger'; debugger<Esc>
nnoremap <Leader>p Orequire 'pry'; binding.pry<Esc>

" Frequently used operations
command! ConvertCamelCaseToUnderScore :%s/\<\u\|\l\u/\=len(submatch(0)) == 1 ? tolower(submatch(0)) : submatch(0)[0].'_'.tolower(submatch(0)[1])/gc
command! ConvertRubyHashSyntax19 :%s/:\([^ ]*\)\(\s*\)=>/\1:/g
command! DeleteComments :g/^\s*#\|\/\//d
command! RemoveTrailingWhitespace :%s/ \+$//g

" CtrlP
let g:ctrlp_max_height = 100
let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = ''

" Wrap quickfix text
autocmd FileType qf setlocal wrap linebreak

" Automatically adjust quickfix height
autocmd FileType qf execute line("$") . "wincmd _"

" Close quickfix with Esc
autocmd FileType qf nnoremap <buffer> <Esc> :cclose<cr>

" Dispatch
nnoremap <Leader>f :FocusDispatch<space>''<left>
nnoremap <Leader>F :FocusDispatch!<cr>
nnoremap <Leader>l :Copen<cr>
nnoremap <Leader>L :Copen!<cr>
nnoremap <Leader>t :wa<cr>:Dispatch<cr>
nnoremap <Leader>T :wa<cr>:Dispatch!<cr>
autocmd FileType go let b:dispatch = 'go test'
autocmd FileType sh let b:dispatch = 'make'
autocmd FileType make let b:dispatch = 'make'
autocmd BufEnter *_spec.rb let b:dispatch = 'bundle exec rspec --format progress %'
autocmd BufEnter *_test.bats compiler bats
autocmd BufEnter *_test.bats let b:dispatch = 'bats --tap %'
autocmd BufEnter *_test.rb let b:dispatch = 'bundle exec testrb %'
autocmd BufEnter Gemfile let b:dispatch = 'bundle'
