require('magicmonty.plug').init(function(use)
  -- Git support
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- Bracket auto closing
  use 'windwp/nvim-autopairs'

  -- Color scheme
  use 'EdenEast/nightfox.nvim'

  -- Nice status line
  use 'nvim-lualine/lualine.nvim'

  -- Auto comment line
  use 'tpope/vim-commentary'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- LSP/Completion config
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
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
  use('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate', branch = '0.5-compat' })
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use('nvim-treesitter/nvim-treesitter-textobjects', { branch = '0.5-compat' })
  use 'nvim-treesitter/nvim-treesitter-angular'
  use 'nvim-treesitter/playground'
  use 'p00f/nvim-ts-rainbow'
  use 'David-Kunz/treesitter-unit'

  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use "rafamadriz/friendly-snippets"

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })
  use 'kyazdani42/nvim-web-devicons'
  use 'fhill2/telescope-ultisnips.nvim'
  use 'jvgrootveld/telescope-zoxide'

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

  -- Orgmode
  use 'kristijanhusak/orgmode.nvim'
  use 'dhruvasagar/vim-table-mode'
  use 'akinsho/org-bullets.nvim'
  use ('michaelb/sniprun', { ['do'] = 'bash install.sh' })

  -- Other
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'editorconfig/editorconfig-vim'
  use 'amadeus/vim-convert-color-to'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'voldikss/vim-floaterm'
  use 'norcalli/nvim-colorizer.lua'
  use 'rcarriga/nvim-notify'

  -- Debugging support
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'


  use 'github/copilot.vim'
end)

-- vim: foldlevel=99
