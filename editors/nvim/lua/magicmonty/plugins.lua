-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone --depth 1 https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

-- Recompile on save
local packer_user_config = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'plugins.lua',
  command = 'source <afile> | PackerCompile',
  group = packer_user_config
})

require('packer').startup({
  function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use 'nvim-lua/popup.nvim'
    use {
      'nathom/filetype.nvim',
      config = function()
        vim.g.did_load_filetypes = 1
      end
    }

    use {
      'kyazdani42/nvim-web-devicons',
      as = 'webdevicons',
      config = function()
        require('magicmonty.plugins.web-devicons.config')
      end
    }

    -- Theme
    use {
      'EdenEast/nightfox.nvim',
      as = 'nightfox',
      after = 'webdevicons',
      config = function()
        require('magicmonty.theme').setup()
      end
    }

    -- Color scheme and nice notification windows
    use({
      'rcarriga/nvim-notify',
      config = function()
        require('magicmonty.plugins.notify.config')
      end,
      requires = { 'nightfox' },
    })

    use { -- LSP Configuration & Plugins
      'VonHeikemen/lsp-zero.nvim',
      after = 'nightfox',
      config = function()
        require('magicmonty.plugins.lsp.config')
      end,
      requires = {
        'nightfox',
        'neovim/nvim-lspconfig',

        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'hrsh7th/cmp-nvim-lua',
        'ray-x/cmp-treesitter',
        { 'dcampos/cmp-emmet-vim', requires = 'mattn/emmet-vim' },

        -- snippets
        {
          'L3MON4D3/LuaSnip',
          config = function()
            require('magicmonty.plugins.luasnip.config')
          end
        },
        'rafamadriz/friendly-snippets',

        -- Useful status updates for LSP
        'j-hui/fidget.nvim',

        -- LSP colorscheme
        'onsails/lspkind-nvim',
        { 'folke/lsp-colors.nvim', requires = 'nightfox' },

        -- UI
        'folke/trouble.nvim',
        'glepnir/lspsaga.nvim',

        { 'windwp/nvim-autopairs', config = function() require('magicmonty.plugins.autopairs.config') end },
      },
    }

    use { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      run = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
      end,
    }

    -- Additional text objects via treesitter
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }
    use { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' }
    use { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' }
    use { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }
    use { 'David-Kunz/treesitter-unit', after = 'nvim-treesitter' }
    use { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' }

    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('magicmonty.plugins.gitsigns.config')
      end
    }

    use {
      'mbbill/undotree',
      config = function()
        require('magicmonty.plugins.undotree.config')
      end
    }

    -- Fancier statusline
    use {
      'nvim-lualine/lualine.nvim',
      after = 'nightfox',
      config = function()
        require('magicmonty.plugins.lualine.config')
      end
    }

    use({
      'romgrk/barbar.nvim',
      requires = {
        'nightfox',
        'webdevicons',
      },
      config = function()
        require('magicmonty.plugins.barbar.config')
      end
    })

    -- Add indentation guides even on blank lines
    use {
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('magicmonty.plugins.indent_blankline.config')
      end
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('magicmonty.plugins.comment.config')
      end
    }
    use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

    -- Fuzzy Finder (files, lsp, etc)
    use {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('magicmonty.plugins.telescope.config')
      end
    }

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    -- Tree view
    use({
      'kyazdani42/nvim-tree.lua',
      requires = 'webdevicons',
      config = function()
        require('magicmonty.plugins.nvim-tree.config')
      end
    })

    if vim.fn.isdirectory('/home/mgondermann/src/plugins/sonicpi.nvim') then
      use({
        '/home/mgondermann/src/plugins/sonicpi.nvim',
        requires = { 'webdevicons', },
        config = function()
          require('magicmonty.plugins.sonicpi.config')
        end
      })
    end

    use {
      'voldikss/vim-floaterm',
      config = function()
        require('magicmonty.plugins.floaterm.config')
      end
    }

    -- Generic helpers
    use('tpope/vim-surround')
    use('tpope/vim-repeat')
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    })
    use('amadeus/vim-convert-color-to')
    use('editorconfig/editorconfig-vim')
    use({
      'stevearc/dressing.nvim',
      config = function()
        require('dressing').setup({})
      end
    })

    -- SCSS syntax support
    use('cakebaker/scss-syntax.vim')

    -- Clojure / Overtone
    use 'guns/vim-clojure-static'
    use 'guns/vim-clojure-highlight'
    use 'tpope/vim-fireplace'
    use 'tpope/vim-classpath'
    use 'tpope/vim-sexp-mappings-for-regular-people'
    use 'kien/rainbow_parentheses.vim'
    use 'guns/vim-sexp'

    -- Nice start page
    use {
      'glepnir/dashboard-nvim',
      config = function()
        require('magicmonty.plugins.dashboard.config').setup()
      end
    }

    -- LaTeX
    use {
      'lervag/vimtex',
      config = function()
        require('magicmonty.plugins.vimtex.config')
      end
    }

    -- fast navigation
    use({
      'ggandor/leap.nvim',
      config = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 'ß', '<Plug>(leap-forward-to)')
      end
    })

    -- REST client
    use {
      'NTBBloodbath/rest.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('magicmonty.plugins.rest.config')
      end
    }

    if is_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  }
})

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this plugins.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- vim: ts=2 sts=2 sw=2 et
