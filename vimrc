"""""""""""""""""""""""""
" Basic features
"""""""""""""""""""""""""
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Display options
syntax on
set cursorline
set number
set list!                       " Display unprintable characters
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«
if $TERM =~ '256color'
  set t_Co=256
elseif $TERM =~ '^xterm$'
  set t_Co=256
endif
colorscheme molokai

" Misc
filetype plugin indent on       " Do filetype detection and load custom file plugins and indent files
set hidden                      " Don't abandon buffers moved to the background
set wildmenu                    " Enhanced completion hints in command line
set wildmode=list:longest,full  " Complete longest common match and show possible matches and wildmenu
set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set complete=.,w,b,u,U,t,i,d    " Do lots of scanning on tab completion
set updatecount=100             " Write swap file to disk every 100 chars
set directory=~/.vim/swap       " Directory to use for the swap file
set diffopt=filler,iwhite       " In diff mode, ignore whitespace changes and align unchanged lines
set history=100                 " Remember 100 commands
set nrformats+=alpha            " Allow incrementing and decrementing letters
                                " - the utility of this is limited by the Tim
                                " Pope plugin that increments Roman Numerals,
                                " but it's still nice to have.

" Indentation and tabbing
set autoindent smartindent
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80

" viminfo: remember certain things when we exit
" (http://vimdoc.sourceforge.net/htmldoc/usr_21.html)
"   %    : saves and restores the buffer list
"   '100 : marks will be remembered for up to 30 previously edited files
"   /100 : save 100 lines from search history
"   h    : disable hlsearch on start
"   "500 : save up to 500 lines for each register
"   :100 : up to 100 lines of command-line history will be remembered
"   n... : where to save the viminfo files
set viminfo=%100,'100,/100,h,\"500,:100,n~/.vim/viminfo

" Undo
set undolevels=10000
if has("persistent_undo")
  set undodir=~/.vim/undo       " Allow undoes to persist even after a file is closed
  set undofile
endif
nnoremap <C-u> :GundoToggle<CR>

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

" to_html settings
let html_number_lines = 0
let html_ignore_folding = 1
let html_use_css = 1
"let html_no_pre = 0
"let use_xhtml = 1
let xml_use_xhtml = 1

" Keybindings to native vim features
let mapleader=","
let localmapleader=","

nmap <Leader>s :%s/
vmap <Leader>s :s/
map <Leader>/ :nohlsearch<cr>
map <Leader>p :setlocal spell!<cr>

" Make Y consistent with D and C
map Y y$

map <Leader>v :vsp<CR>

vnoremap . :normal .<CR>
vnoremap @ :normal! @

map <C-j> :bn<cr>
map <C-k> :bp<cr>
map <C-PageDown> :cnext<cr>
map <C-PageUp> :cprev<cr>

"""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""
nnoremap <C-g> :NERDTreeToggle<cr>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '\.so$', 
    \ '\.egg$', '^\.git$', '\~$', '\.cmi', '\.cmo']
let NERDTreeHighlightCursorline=1
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1

" Put a space around comment markers
let g:NERDSpaceDelims = 1

nnoremap <C-y> :YRShow<cr>
let g:yankring_history_dir = '$HOME/.vim'
let g:yankring_manual_clipboard_check = 0

map <Leader>l :MiniBufExplorer<cr>
let g:miniBufExplorerMoreThanOne = 10000
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplSplitBelow=1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplVSplit = 20

let g:syntastic_enable_signs=1
let g:syntastic_check_on_open=1
" C and Scala take too long to run, and scss misses imports
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['c', 'scss', 'scala'] }

let g:quickfixsigns_classes=['qfl', 'vcsdiff', 'breakpoints']

let g:Powerline_symbols = 'unicode'
set laststatus=2

let g:ctrlp_map = '<c-e>'
let g:ctrlp_custom_ignore = '/\.\|\.o\|\.so'

noremap <Leader>t= :Tabularize /=<CR>
noremap <Leader>t: :Tabularize /^[^:]*:\zs/l0l1<CR>
noremap <Leader>t> :Tabularize /=><CR>
noremap <Leader>t- :Tabularize /-><CR>
noremap <Leader>t, :Tabularize /,\zs/l0l1<CR>

nnoremap <Leader>b :TagbarToggle<CR>

"""""""""""""""""""""""""
" Custom functions
"""""""""""""""""""""""""
:command -bar -nargs=1 OpenURL :!firefox <args>

" http://stackoverflow.com/questions/2182427/right-margin-in-vim
function! s:ToggleColorColumn()
    if s:color_column_old == 0
        let s:color_column_old = &colorcolumn
        windo let &colorcolumn = 0
    else
        windo let &colorcolumn=s:color_column_old
        let s:color_column_old = 0
    endif
endfunction

if exists('+colorcolumn')
  set colorcolumn=81
  let s:color_column_old = 0
  nnoremap <Leader>m :call <SID>ToggleColorColumn()<cr>
else
  au BufWinEnter * HighlightLongLines
endif

" When opening a file, always jump to the last cursor position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \     exe "normal g'\"" |
    \ endif |

" Screen settings
let g:ScreenImpl = 'Tmux'
let g:ScreenShellTmuxInitArgs = '-2'
let g:ScreenShellInitialFocus = 'shell'
let g:ScreenShellQuitOnVimExit = 0
map <F5> :ScreenShellVertical<CR>
command -nargs=? -complete=shellcmd W  :w | :call ScreenShellSend("load '".@%."';")
map <Leader>c :ScreenShellVertical bundle exec rails c<CR>
map <Leader>e :w<CR> :call ScreenShellSend("cucumber --format=pretty ".@% . ':' . line('.'))<CR>
map <Leader>r :w<CR> :call ScreenShellSend("rspec ".@% . ':' . line('.'))<CR>
map <Leader>f :w<CR> :call ScreenShellSend("Rails.logger.level = Logger::WARN;\n".
                                         \ "rspec ".@%."\n".
                                         \ "Rails.logger.level = Logger::DEBUG;")<CR>
map <Leader>d :w<CR> :call ScreenShellSend("Rails.logger.level = Logger::WARN;\n".
                                         \ "cucumber ".@%."\n".
                                         \ "Rails.logger.level = Logger::DEBUG;")<CR>

" Always edit file, even when swap file is found
set shortmess+=A

" Toggle paste mode while in insert mode with F12
set pastetoggle=<F12>
