call plug#begin('~/.vim-plug')

" Windows
Plug 'PProvost/vim-ps1'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-shell'

" Blog
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'KabbAmine/vCoolor.vim'

" Clojure
Plug 'terryma/vim-expand-region'

" Colors
Plug 'morhetz/gruvbox'

" .NET
Plug 'OrangeT/vim-csharp'
Plug 'fsharp/vim-fsharp', { 'for': 'fsharp', 'do': 'make fsautocomplete' }
Plug 'OmniSharp/omnisharp-vim', { 'do': 'git submodule update --init --recursive && cd server && msbuild' }
Plug 'Traap/vim-helptags'

" General
Plug 'jlanzarotta/bufexplorer'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'kien/ctrlp.vim'
if !has('nvim')
	Plug 'Shougo/neocomplete.vim'
endif
Plug 'vim-scripts/tComment'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-textobj-user'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-syntastic/syntastic'
Plug 'Shougo/denite.nvim'
Plug 'rking/ag.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tpope/vim-cucumber'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'SirVer/ultisnips'
Plug 'freitass/todo.txt-vim'
Plug 'chaoren/vim-wordmotion'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'dag/vim-fish'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" NVim
if has('nvim')
	Plug 'Shougo/deoplete.nvim'
	Plug 'fszymanski/deoplete-emoji'
	Plug 'callmekohei/deoplete-fsharp'
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

