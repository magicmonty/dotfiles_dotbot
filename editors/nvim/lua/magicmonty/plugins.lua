require('magicmonty.plug').init(function(use)
  -- Git support
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- Bracket auto closing
  use 'cohama/lexima.vim'

  -- Color scheme
  use 'EdenEast/nightfox.nvim'

  -- Nice status line
  use 'nvim-lualine/lualine.nvim'

  -- Auto comment line
  use 'tpope/vim-commentary'

  -- LSP/Completion config
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'ray-x/cmp-treesitter'
  use 'glepnir/lspsaga.nvim'
  use 'folke/lsp-colors.nvim'
  use 'onsails/lspkind-nvim'
  use 'folke/trouble.nvim'
  use 'folke/lua-dev.nvim'

  -- Treesitter
  use('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use('nvim-treesitter/nvim-treesitter-textobjects', { branch = '0.5-compat' })
  use 'nvim-treesitter/nvim-treesitter-angular'
  use 'p00f/nvim-ts-rainbow'
  use 'David-Kunz/treesitter-unit'

  -- Snippets
  use "SirVer/UltiSnips"
  use "quangnguyen30192/cmp-nvim-ultisnips"

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'fhill2/telescope-ultisnips.nvim'

  use('groenewege/vim-less', { ['for'] = 'less' })

  -- Clojure / Overtone
  use 'guns/vim-clojure-static'
  use 'guns/vim-clojure-highlight'
  use 'tpope/vim-fireplace'
  use 'tpope/vim-classpath'
  use 'tpope/vim-sexp-mappings-for-regular-people'
  use 'kien/rainbow_parentheses.vim'
  use 'guns/vim-sexp'

  -- Sonic Pi
  use 'dermusikman/sonicpi.vim'

  -- Other
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'editorconfig/editorconfig-vim'
  use 'amadeus/vim-convert-color-to'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'kassio/neoterm'
  use 'norcalli/nvim-colorizer.lua'
  use 'rcarriga/nvim-notify'

  use 'github/copilot.vim'
end)

