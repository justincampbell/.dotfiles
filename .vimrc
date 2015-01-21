call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'andrewradev/switch.vim'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'bling/vim-airline'
Plug 'dockyard/vim-easydir'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'ivyl/vim-bling'
Plug 'justincampbell/vim-eighties'
Plug 'justincampbell/vim-railscasts'
Plug 'kien/ctrlp.vim'
Plug 'kien/rainbow_parentheses.vim'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/multvals.vim'
Plug 'wikitopian/hardmode'

" Clojure
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-leiningen'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" CoffeeScript
Plug 'kchmck/vim-coffee-script'

" Docker
Plug 'ekalinin/Dockerfile.vim'

" Elixir
Plug 'elixir-lang/vim-elixir'

" Go
Plug 'fatih/vim-go'

" Haskell
Plug 'dag/vim2hs'
Plug 'eagletmt/ghcmod-vim'
Plug 'shougo/vimproc.vim'

" JavaScript
Plug 'pangloss/vim-javascript'

" JSON
Plug 'elzr/vim-json'

" Markdown
Plug 'nelstrom/vim-markdown-folding'
Plug 'tpope/vim-markdown'

" OCaml
Plug 'ocamlpro/ocp-indent'
Plug 'the-lambda-church/merlin'

" Ruby
Plug 'ecomba/vim-ruby-refactoring'
Plug 'hwartig/vim-seeing-is-believing'
Plug 'jgdavey/vim-blockle'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'

" Rust
Plug 'wting/rust.vim'

" Scala
Plug 'derekwyatt/vim-scala'

" Shell
Plug 'markcornick/vim-bats'
Plug 'rosstimson/bats.vim'

" Slim
Plug 'slim-template/vim-slim'

" Thrift
Plug 'solarnz/thrift.vim'

call plug#end()

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

" vim-airline
let g:airline_left_alt_sep=''
let g:airline_right_alt_sep=''
let g:airline_section_a='' " mode
let g:airline_section_b='' " branch
let g:airline_section_z='' " ruler
let g:airline_theme='monochrome'

" Sort
vnoremap <Leader>s :sort<cr>

" Alignment
vnoremap <Leader>a# :Tabularize /#<CR>
vnoremap <Leader>a( :Tabularize /(/l1l0<CR>
vnoremap <Leader>a, :Tabularize /,\zs/l0r1<CR>
vnoremap <Leader>a/ :Tabularize /\/\/<CR>
vnoremap <Leader>a: :Tabularize /:\zs/l0r1<CR>
vnoremap <Leader>a<Space> :Tabularize /<Space><CR>
vnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a\| :Tabularize /\|<CR>

" Macro repeat
nnoremap <Space> @q

" Insert debuggers
nnoremap <Leader>d Orequire 'debugger'; debugger<Esc>
nnoremap <Leader>p Orequire 'pry'; binding.pry<Esc>

" Exit insert mode with jk/kj
inoremap jk <Esc>
inoremap kj <Esc>

" Frequently used operations
command! ConvertCamelCaseToUnderScore :%s/\<\u\|\l\u/\=len(submatch(0)) == 1 ? tolower(submatch(0)) : submatch(0)[0].'_'.tolower(submatch(0)[1])/gc
command! ConvertRubyHashSyntax19 :%s/:\([^ ]*\)\(\s*\)=>/\1:/g
command! DeleteComments :g/^\s*#\|\/\//d
command! RemoveTrailingWhitespace :%s/ \+$//g

" The Silver Searcher
let g:ag_binary = system("which ag | xargs echo -n")

" CtrlP
let g:ctrlp_max_height = 100
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = g:ag_binary . ' %s -l --nocolor -g ""'
let g:ctrlp_working_path_mode = ''

" Switch
nnoremap <leader>- :Switch<CR>

" Wrap quickfix text
autocmd FileType qf setlocal wrap linebreak

" Automatically adjust quickfix height
autocmd FileType qf execute line("$") . "wincmd _"

" Remove color column in quickfix
autocmd FileType qf set colorcolumn=0

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
