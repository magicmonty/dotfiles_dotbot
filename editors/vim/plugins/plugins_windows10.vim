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
Plug 'Traap/vim-helptags'

" General
Plug 'jlanzarotta/bufexplorer'
Plug 'kien/rainbow_parentheses.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'kien/ctrlp.vim'
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

call plug#end()


