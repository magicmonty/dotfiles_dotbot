call plug#begin('~/.vim-plug')

" Blog
Plug 'vim-scripts/liquid.vim'
Plug 'vim-scripts/liquidfold.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'parkr/vim-jekyll'
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }

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
if !has('nvim')
	Plug 'Shougo/neocomplete.vim'
else
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'fszymanski/deoplete-emoji'

  " function! BuildDeopleteFSharp(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    " if a:info.status == 'installed' || a:info.force
      " !bash install.bash
      " :UpdateRemotePlugins
    " endif
  " endfunction

  " Plug 'callmekohei/deoplete-fsharp', { 'do': function('BuildDeopleteFSharp') }
endif
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go'
Plug 'lambdatoast/elm.vim'
Plug 'vim-syntastic/syntastic'
Plug 'aklt/plantuml-syntax'
Plug 'tpope/vim-cucumber'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
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
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" LaTeX
Plug 'lervag/vimtex'

call plug#end()

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

