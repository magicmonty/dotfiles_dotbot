call plug#begin('~/.vim-plug')

source ~/.vim/plugins_shared.vim

" Blog
Plug 'parkr/vim-jekyll'

" Clojure
Plug 'tpope/vim-classpath', { 'for': 'clojure' }
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'magicmonty/sonicpi.vim'
Plug 'rizzatti/dash.vim'

" .NET
Plug 'OrangeT/vim-csharp'
Plug 'fsharp/vim-fsharp', { 'for': 'fsharp', 'do': 'make fsautocomplete' }
Plug 'OmniSharp/omnisharp-vim', { 'do': 'git submodule update --init --recursive && cd server && xbuild' }

Plug 'romainl/Apprentice'

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

