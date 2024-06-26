call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'andrewradev/switch.vim'
Plug 'dockyard/vim-easydir'
Plug 'github/copilot.vim'
Plug 'godlygeek/tabular'
Plug 'ivyl/vim-bling'
Plug 'janko-m/vim-test'
Plug 'jgdavey/tslime.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'justincampbell/vim-eighties'
Plug 'justincampbell/vim-railscasts'
Plug 'kien/rainbow_parentheses.vim'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'shougo/unite.vim'
Plug 'shougo/vimfiler.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-db'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/multvals.vim'
Plug 'vim-scripts/syntaxattr.vim'
Plug 'w0rp/ale'

" Coc
Plug 'neoclide/coc.nvim', {
      \ 'branch': 'release',
      \ 'do': ':CocInstall coc-json coc-solargraph coc-tsserver' }

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" CSS
Plug 'ap/vim-css-color'

" Docker
Plug 'ekalinin/Dockerfile.vim'

" Go
Plug 'fatih/vim-go'

" HCL
Plug 'fatih/vim-hclfmt'
Plug 'b4b4r07/vim-hcl'

" HTML
Plug 'mattn/emmet-vim'

" JavaScript
Plug 'mustache/vim-mustache-handlebars'
Plug 'pangloss/vim-javascript'

" JSON
Plug 'elzr/vim-json'

" Markdown
Plug 'nelstrom/vim-markdown-folding'
Plug 'tpope/vim-markdown'

" Ruby
Plug 'alexbel/vim-rubygems'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'hwartig/vim-seeing-is-believing'
Plug 'jgdavey/vim-blockle'
Plug 'tpope/vim-rake'
Plug 'vim-ruby/vim-ruby'

" Shell
Plug 'markcornick/vim-bats'
Plug 'rosstimson/bats.vim'

" Terraform
Plug 'bkad/vim-terraform'

call plug#end()

" MacVim
set guifont=Monaco:h18
set guioptions+=c " No popup dialogs
set guioptions-=L " Hide vertical scrollbars
set guioptions-=r " Hide scrollbars

" Mouse
set mouse=a

" Automatically reload files
set autoread

" Lazily redraw screen
set lazyredraw

" Set swap/backup location
set backupdir=/tmp
set directory=/tmp
set updatetime=250

" Colors
autocmd ColorScheme * highlight Visual ctermbg=236
colorscheme railscasts
set background=dark
syntax on
highlight GitGutterAdd ctermfg=28
highlight! link Conceal SpecialKey
highlight! link Search IncSearch
highlight! link qfLineNr WarningMsg

" Hide search results automatically
autocmd BufWinLeave,BufWrite,InsertEnter * let @/ = ""

" Sign and number columns
highlight SignColumn ctermbg=0 guibg=#111111
highlight NonText ctermbg=0 ctermfg=0 guibg=#000000
highlight Vertsplit ctermbg=233 ctermfg=233 guibg=#111111

" Tabs
highlight! link TabLineFill CursorColumn
highlight TabLine ctermfg=7 ctermbg=234 cterm=none
highlight TabLineSel ctermfg=203 ctermbg=234
map <Tab> :tabn<cr>
map <S-Tab> :tabp<cr>

" Line numbers
set number
set numberwidth=1

" Don't wrap text
set nowrap

" Backspace over anything
set backspace=eol,indent,start

" ALE
highlight! ALEErrorLine cterm=underline ctermfg=1
highlight! ALEWarningLine cterm=underline ctermfg=3
highlight! ALEVirtualTextError cterm=underline,bold ctermfg=1
highlight! ALEVirtualTextWarning cterm=underline,bold ctermfg=3

let g:ale_cursor_detail = 1
let g:ale_echo_msg_error_str = '❗️'
let g:ale_echo_msg_format = '[%linter%] %severity% %s'
let g:ale_echo_msg_warning_str = '🙄'
let g:ale_fix_on_save = 1
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_set_highlights = 1
let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
let g:ale_virtualtext_prefix = '%severity%%linter%% code%: '

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier', 'importjs']
let g:ale_fixers['ruby'] = ['rubocop', 'standardrb']

let g:ale_linters = {}
let g:ale_linters['go'] = ['go build', 'golint']
let g:ale_linters['handlebars'] = ['ember-template-lint']
let g:ale_linters['html'] = []
let g:ale_linters['ruby'] = ['ruby']
let g:ale_linters['sh'] = ['shellcheck']
let g:ale_linters['sql'] = ['sqlint']
let g:ale_linters['vim'] = ['vint']

" Prettier
autocmd BufWritePre *.js Prettier
autocmd BufWritePre *.jsx Prettier
autocmd BufWritePre *.ts Prettier
autocmd BufWritePre *.tsx Prettier

" Soft tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=4

" Fancy characters
set listchars=tab:›\ ,trail:·,extends:⇢,precedes:⇠
autocmd FileType go set listchars=tab:\ \ ,trail:·,extends:⇢,precedes:⇠
set list

" Highlight trailing whitespace
highlight! link ExtraWhitespace Todo
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufWinLeave * call clearmatches()

" Filetype mappings
autocmd BufNewFile,BufRead *.avsc setlocal filetype=json
autocmd BufNewFile,BufRead *.crl setlocal filetype=ruby
autocmd BufNewFile,BufRead *.jbuilder setlocal filetype=ruby
autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=markdown
autocmd BufNewFile,BufRead *.skim setlocal filetype=slim

" Filetype-specific settings
autocmd FileType gitcommit,markdown setlocal nonumber
autocmd FileType gitcommit,markdown setlocal spell
autocmd FileType go nnoremap <Leader>gc :GoCoverageToggle<cr>
autocmd FileType markdown,"" setlocal linebreak
autocmd FileType markdown,"" setlocal wrap
autocmd FileType javascript inoremap #{ ${
" autocmd FileType ruby nnoremap gd :Ag '^\s*(def\|class\|module)\s.*(self\.)?<cword>[\s\($]'<cr>
autocmd FileType terraform inoremap #{ ${
autocmd FileType terraform inoremap do<cr> {<cr><cr>}<Up><Tab>
autocmd FileType terraform inoremap {<cr> {<cr><cr>}<Up><Tab>

" 80-column line
set colorcolumn=81
highlight! link ColorColumn CursorColumn

" Smart search
set ignorecase
set inccommand=split
set incsearch
set smartcase

" Smarter split opening
set splitbelow
set splitright

" Scroll before the cursor reaches the edge
set scrolloff=5

" Show leader keystrokes in the bottom right
set showcmd

" Extra leader mappings
nmap , \
vmap , \

" Always show filename
set laststatus=2

" VimFiler
let g:netrw_menu = 0
let g:vimfiler_as_default_explorer = 1

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
      \ ['lightblue',  'lightblue'],
      \ ['lightgreen', 'lightgreen'],
      \ ['lightred',   'lightred'],
      \ ['darkblue',   'darkblue'],
      \ ['darkgreen',  'darkgreen'],
      \ ['darkred',    'darkred'],
      \ ['blue',       'blue'],
      \ ['green',      'green'],
      \ ['red',        'red'],
      \ ]
let g:rbpt_colorpairs = g:rbpt_colorpairs + g:rbpt_colorpairs
let g:rbpt_max = len(g:rbpt_colorpairs)

" seeing-is-beleiving
map <F4> <Plug>(seeing-is-believing-mark)
imap <F4> <Plug>(seeing-is-believing-mark)
map <F5> <Plug>(seeing-is-believing-run)
imap <F5> <Plug>(seeing-is-believing-run)

" vim-airline
function ConfigureAirline()
  let g:airline#extensions#ale#error_symbol = '❗️'
  let g:airline#extensions#ale#warning_symbol = '🙄'
  let g:airline_left_alt_sep=''
  let g:airline_right_alt_sep=''
  let g:airline_section_a='' " mode
  let g:airline_section_b='' " branch
  let g:airline_section_y='' " encoding
  let g:airline_section_z = airline#section#create(['%2l/%L']) " ruler
  let g:airline_theme='monochrome'
endfunction
autocmd User AirlineAfterInit call ConfigureAirline()

" Sort
vnoremap <Leader>s :sort<cr>

" Alignment
vnoremap <Leader>a# :Tabularize /#<CR>
vnoremap <Leader>a( :Tabularize /(/l1l0<CR>
vnoremap <Leader>a, :Tabularize /,\zs/l0r1<CR>
vnoremap <Leader>a- :Tabularize /-/l1r0<CR>
vnoremap <Leader>a/ :Tabularize /\/\/<CR>
vnoremap <Leader>a: :Tabularize /:\zs/l0r1<CR>
vnoremap <Leader>a; :Tabularize /;\zs/l0r1<CR>
vnoremap <Leader>a<Space> :Tabularize /<Space><CR>
vnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a\| :Tabularize /\|<CR>

" Macro repeat
nnoremap <Space> @q

" Frequently used operations
command! ConvertCamelCaseToUnderScore :%s/\<\u\|\l\u/\=len(submatch(0)) == 1 ? tolower(submatch(0)) : submatch(0)[0].'_'.tolower(submatch(0)[1])/gc
command! ConvertRubyHashSyntax19 :%s/:\([^ ]*\)\(\s*\)=>/\1:/g
command! DeleteComments :g/^\s*#\|\/\//d
command! RemoveTrailingWhitespace :%s/ \+$//g

" fzf
nnoremap <C-P> :FzfFiles<CR>
command! -bang -nargs=? -complete=dir FzfFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--padding=0', '--margin=0']}), <bang>0)

" Switch
nnoremap <leader>- :Switch<CR>
let g:switch_custom_definitions =
    \ [
    \   ['==', '!='],
    \   ['assert', 'refute'],
    \   ['enable', 'disable'],
    \   ['if' , 'unless'],
    \ ]

" Wrap quickfix text
autocmd FileType qf setlocal wrap linebreak

" Automatically adjust quickfix height
autocmd FileType qf execute min([line("$"), &lines * 2/5]) . "wincmd _"

" Remove color column in quickfix
autocmd FileType qf set colorcolumn=0

" vim-go
highlight! link goSameId SpellRare
let g:go_fmt_command = "goimports"
let g:go_gocode_propose_source = 1

" coc
highlight! Pmenu ctermfg=7 ctermbg=235
highlight! CocSearch ctermfg=15

autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
xmap <leader>f  <Plug>(coc-format-selected)

nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Accept with tab or return, close with esc
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"

" Completion
set completeopt=

" Goyo/Limelight
let g:goyo_height = '100%'
let g:limelight_conceal_ctermfg = 'gray'

function! s:goyo_enter()
  Limelight
  silent !tmux set status off
endfunction

function! s:goyo_leave()
  Limelight!
  silent !tmux set status on
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" vim-test
let g:test#javascript#jest#options = '--no-color'
autocmd WinEnter,VimResized * call SetTestStrategy()
function! SetTestStrategy()
  if (winheight('%') > 40)
    let g:test#strategy = "tslime"
  else
    let g:test#strategy = "dispatch"
  endif
endfunction
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
nnoremap <silent> <Leader>t :wa<CR>:TestFile<CR>
nnoremap <silent> <Leader>T :wa<cr>:TestNearest<CR>

" Projectionist
let g:projectionist_heuristics =
      \ {
      \   "go.mod": {
      \     '*.go':      { 'alternate': '{}_test.go'},
      \     '*_test.go': { 'alternate': '{}.go'},
      \   },
      \   "package.json": {
      \     '*.js':      { 'alternate': '{}.test.js'},
      \     '*.test.js': { 'alternate': '{}.js'},
      \     '*.ts':      { 'alternate': '{}.test.ts'},
      \     '*.test.ts': { 'alternate': '{}.ts'},
      \   },
      \   "Gemfile": {
      \     'app/*.rb':  { 'alternate': 'spec/{}_spec.rb'},
      \   },
      \ }

" Dispatch
nnoremap <Leader>f :FocusDispatch<space>''<left>
nnoremap <Leader>F :FocusDispatch!<CR>
nnoremap <Leader>l :Copen<CR>
nnoremap <Leader>L :Copen!<CR>
nnoremap <Leader>m :wa<CR>:Dispatch<CR>
nnoremap <Leader>M :wa<CR>:Dispatch!<CR>
autocmd FileType go let b:dispatch = 'go test'
autocmd FileType make let b:dispatch = 'make'
autocmd FileType sh let b:dispatch = 'make'
autocmd FileType terraform let b:dispatch = 'terraform plan -input=false'
autocmd BufEnter *.bats compiler bats
autocmd BufEnter *.bats let b:dispatch = 'bats --tap %'
autocmd BufEnter *.gemspec let b:dispatch = 'bundle'
autocmd BufEnter *_spec.rb let b:dispatch = 'bundle exec rspec --format progress %'
autocmd BufEnter *_test.js let b:dispatch = 'npm test'
autocmd BufEnter *_test.rb let b:dispatch = 'bundle exec testrb %'
autocmd BufEnter Gemfile let b:dispatch = 'bundle'
autocmd BufEnter db/migrate/*.rb let b:dispatch = 'bundle exec rake db:migrate'
