local fn = vim.fn
local au = require('vim_ext').au
local augroup = require('vim_ext').augroup
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim.git',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
end

augroup('packer_user_config', {
  au({ 'BufWritePost', 'plugins.lua', 'source <afile> | PackerCompile' }),
})

return require('packer').startup({
  function(use)
    use('wbthomason/packer.nvim')

    -- common dependencies
    use({
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('settings.web-devicons.settings')
      end,
    })
    use('nvim-lua/plenary.nvim')
    use({
      'nvim-lua/lsp-status.nvim',
      config = function()
        require('settings.lsp-status.settings')
      end,
    })

    -- Display keybindings
    use({
      'folke/which-key.nvim',
      config = function()
        require('settings.which-key.settings')
      end,
    })

    -- Color scheme
    use({
      'EdenEast/nightfox.nvim',
      config = function()
        require('settings.nightfox.settings')
      end,
      requires = {
        'kyazdani42/nvim-web-devicons',
        'lukas-reineke/indent-blankline.nvim',
      },
    })

    use({
      'folke/lsp-colors.nvim',
      config = function()
        require('settings.lsp-colors.settings')
      end,
      requires = 'EdenEast/nightfox.nvim',
    })

    -- Color scheme and nice notification windows
    use({
      'rcarriga/nvim-notify',
      config = function()
        require('settings.notify.settings')
      end,
      requires = 'EdenEast/nightfox.nvim',
    })

    -- Tree view
    use({
      'kyazdani42/nvim-tree.lua',
      config = function()
        require('settings.nvim-tree.settings')
      end,
      requires = 'kyazdani42/nvim-web-devicons',
    })

    -- Statusline / Tabline
    use({
      'nvim-lualine/lualine.nvim',
      config = function()
        require('settings.lualine.settings')
      end,
      requires = { 'kyazdani42/nvim-web-devicons', 'nvim-lua/lsp-status.nvim' },
    })

    use({
      'kdheepak/tabline.nvim',
      config = function()
        require('settings.tabline.settings')
      end,
    })

    -- Git support
    use('tpope/vim-fugitive')
    use({
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end,
      requires = 'nvim-lua/plenary.nvim',
    })

    -- Auto commenter
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('settings.comment.settings')
      end,
    })

    -- Treesitter
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('settings.treesitter.settings')
      end,
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-treesitter/nvim-treesitter-textobjects',
        -- 'nvim-treesitter/nvim-treesitter-angular',
        'nvim-treesitter/playground',
        'windwp/nvim-ts-autotag',
        'p00f/nvim-ts-rainbow',
        'David-Kunz/treesitter-unit',
        'folke/lsp-colors.nvim',
        'JoosepAlviste/nvim-ts-context-commentstring',
      },
    })

    -- LSP/Completion config
    use({
      'williamboman/nvim-lsp-installer',
      config = function()
        require('settings.lsp-installer.settings')
      end,
      requires = {
        'neovim/nvim-lspconfig',
        'folke/lua-dev.nvim',
        'kyazdani42/nvim-web-devicons',
        'folke/lsp-colors.nvim',
        'nvim-lua/lsp-status.nvim',
      },
    })

    use({
      'mhartington/formatter.nvim',
      config = function()
        require('settings.formatter.settings')
      end,
    })

    use({
      'hrsh7th/nvim-cmp',
      config = function()
        require('settings.cmp.settings')
      end,
      requires = {
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-document-symbol',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'ray-x/cmp-treesitter',
        {
          'onsails/lspkind-nvim',
          config = function()
            require('settings.lspkind.settings')
          end,
        },
        {
          'L3MON4D3/LuaSnip',
          config = function()
            require('settings.luasnip.settings')
          end,
          requires = {
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
          },
        },
        -- Bracket auto closing
        {
          'windwp/nvim-autopairs',
          config = function()
            require('settings.autopairs.settings')
          end,
        },
      },
    })

    -- Telescope
    use({
      'nvim-telescope/telescope.nvim',
      config = function()
        require('settings.telescope.settings')
      end,
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-lua/popup.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        'nvim-telescope/telescope-project.nvim',
        {
          'nvim-telescope/telescope-dap.nvim',
          requires = {
            {
              'mfussenegger/nvim-dap',
              config = function()
                require('settings.nvim-dap.settings')
              end,
              requires = {
                'rcarriga/nvim-dap-ui',
                'theHamsta/nvim-dap-virtual-text',
              },
            },
          },
        },
        'jvgrootveld/telescope-zoxide',
        {
          'AckslD/nvim-neoclip.lua',
          config = function()
            require('neoclip').setup()
          end,
        },
      },
    })

    -- Better Terminal
    use({
      'voldikss/vim-floaterm',
      config = function()
        require('settings.floaterm.settings')
      end,
    })

    -- Generic helpers
    use('tpope/vim-surround')
    use('tpope/vim-repeat')
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })
    use('amadeus/vim-convert-color-to')
    use('editorconfig/editorconfig-vim')
    use({
      'stevearc/dressing.nvim',
      config = function()
        require('settings.dressing.settings')
      end,
    })

    -- SCSS syntax support
    use('cakebaker/scss-syntax.vim')

    -- Org Mode support
    use({
      'kristijanhusak/orgmode.nvim',
      config = function()
        require('settings.orgmode.settings')
      end,
      requires = {
        'dhruvasagar/vim-table-mode',
        'akinsho/org-bullets.nvim',
        { 'michaelb/sniprun', run = 'bash install.sh' },
      },
    })

    -- Clojure / Overtone
    use('guns/vim-clojure-static')
    use('guns/vim-clojure-highlight')
    use('tpope/vim-fireplace')
    use('tpope/vim-classpath')
    use('tpope/vim-sexp-mappings-for-regular-people')
    use('kien/rainbow_parentheses.vim')
    use('guns/vim-sexp')

    -- Sonic Pi
    use('dermusikman/sonicpi.vim')

    -- Other
    use('mattn/emmet-vim')

    -- Test runner support
    use('vim-test/vim-test')
    use('rcarriga/vim-ultest', { ['do'] = ':UpdateRemotePlugins' })

    -- PHP
    use('StanAngeloff/php.vim')
    use('github/copilot.vim')

    -- Note taking
    use({
      'vimwiki/vimwiki',
      requires = {
        'EdenEast/nightfox.nvim',
      },
      config = function()
        require('settings.vimwiki.settings')
      end,
    })

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
