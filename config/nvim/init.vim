set nocompatible
call plug#begin('~/.local/share/nvim/plugged')

" Aesthetics
Plug 'sheerun/vim-polyglot'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'itchyny/lightline.vim'
Plug 'flazz/vim-colorschemes'

" Language Server Protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'jackguo380/vim-lsp-cxx-highlight'

" Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Utility
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'

call plug#end()


"True Color support
if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" UI Configs
set number
set showmatch
set incsearch
set hlsearch

" Mouse
set mouse=a

" Aesthetics
set t_Co=256
colorscheme SweetCandy
hi NonText ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi Comment guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

" Syntax
syntax on
filetype plugin on
filetype indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set cindent
autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen " set C files to have doxygen comments

" Universal Clipboard (uncomment on barebone linux)
"set clipboard=unnamedplus
"let g:clipboard = {
"          \   'name': 'myClipboard',
"          \   'copy': {
"          \      '+': ['gpaste-client'],
"          \      '*': ['*'],
"          \    },
"          \   'paste': {
"          \      '+': ['gpaste-client', 'get', '--use-index', '0'],
"          \      '*': ['*'],
"          \   },
"          \   'cache_enabled': 1,
"          \ }

" Go to tab by number
:let mapleader = "\<Space>"
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

" Tabs
set showtabline=2

" === PLUGIN OPTIONS ===


" --> Vim-LSP

" CCLS Server
if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {
	  \		'highlight': { 'lsRanges' : v:true },
	  \ },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc', 'c.doxygen'],
      \ })
endif

" HTML Server
if executable('html-languageserver')                         
  au User lsp_setup call lsp#register_server({               
    \ 'name': 'html-languageserver',                     
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},                                   
    \ 'whitelist': ['html'],                             
  \ })                                                       
endif   

" Flow JavaScript
if executable('flow')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

" CSS Server
if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
        \ })
endif

" Language Server Configs
let g:lsp_signs_error = {'text': 'x'}
let g:lsp_signs_warning = {'text': '!'}
let g:lsp_signs_hint = {'text': '?'}
let g:lsp_virtual_text_enabled = 1
let g:lsp_highlight_references_enabled = 1


" --> coc.vim

" Tab Completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <expr> <cr>    coc#pum#visible() ? coc#pum#confirm() : "\<cr>"
" Go to
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" --> NERDTree

nnoremap gn :NERDTreeToggle<CR>
map gj :%!jq .<CR>

" --> Lightline

set noshowmode
let g:lightline = {
    \ 'colorscheme': 'powerlineish',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
	\             [ 'gitbranch', 'readonly', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
    \ }
