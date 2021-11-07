local Plug = vim.fn["plug#"]
vim.call("plug#begin", "~/.config/nvim-data/plugged")

-- Git support
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

-- Bracket auto closing
Plug 'cohama/lexima.vim'

-- Color scheme
Plug 'EdenEast/nightfox.nvim'

-- Nice status line
Plug 'nvim-lualine/lualine.nvim'

-- Auto comment line
Plug 'tpope/vim-commentary'

-- LSP/Completion config
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/cmp-treesitter'
Plug 'glepnir/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'folke/trouble.nvim'
Plug 'folke/lua-dev.nvim'
Plug 'aca/emmet-ls'

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug('nvim-treesitter/nvim-treesitter-textobjects', { branch = '0.5-compat' })
Plug 'nvim-treesitter/nvim-treesitter-angular'
Plug 'p00f/nvim-ts-rainbow'
Plug 'David-Kunz/treesitter-unit'

-- Snippets
Plug "SirVer/UltiSnips"
Plug "quangnguyen30192/cmp-nvim-ultisnips"

-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'fhill2/telescope-ultisnips.nvim'

Plug('groenewege/vim-less', { ['for'] = 'less' })

-- Clojure / Overtone
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-sexp'

-- Sonic Pi
Plug 'dermusikman/sonicpi.vim'

-- Other
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'editorconfig/editorconfig-vim'
Plug 'amadeus/vim-convert-color-to'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'kassio/neoterm'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'rcarriga/nvim-notify'

Plug 'github/copilot.vim'

vim.call "plug#end"

