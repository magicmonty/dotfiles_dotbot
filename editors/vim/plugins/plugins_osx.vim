call plug#begin('~/.vim-plug')

" Blog
Plug 'mattn/emmet-vim'
Plug 'vim-scripts/liquid.vim'
Plug 'vim-scripts/liquidfold.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'parkr/vim-jekyll'
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'KabbAmine/vCoolor.vim'

" Clojure
Plug 'tpope/vim-classpath', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'

" Colors
Plug 'morhetz/gruvbox'

" .NET
Plug 'OrangeT/vim-csharp'
Plug 'fsharp/vim-fsharp', { 'for': 'fsharp', 'do': 'make fsautocomplete' }
Plug 'OmniSharp/omnisharp-vim', { 'do': 'git submodule update --init --recursive && cd server && xbuild' }
Plug 'Traap/vim-helptags'

" General
Plug 'jlanzarotta/bufexplorer'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'ctrlpvim/ctrlp.vim'
if !has('nvim')
	Plug 'Shougo/neocomplete.vim'
endif
Plug 'vim-scripts/tComment'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
Plug 'lambdatoast/elm.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'aklt/plantuml-syntax'
Plug 'tpope/vim-cucumber'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'freitass/todo.txt-vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'dag/vim-fish'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind']}

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" NVim
if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'fszymanski/deoplete-emoji'
  " Plug 'callmekohei/deoplete-fsharp'
endif

" LaTeX
Plug 'lervag/vimtex'

" OSX
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    Plug 'rizzatti/dash.vim'
  endif
endif

call plug#end()

if has('syntax') && has('eval') && !has('nvim')
  packadd matchit
endif

if has('nvim')
	let g:deoplete#enable_smart_case = 1
	let g:deoplete#enable_at_startup = 1

	inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	function! s:my_cr_function() abort
  		return deoplete#close_popup() . "\<CR>"
	endfunction
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
endif

