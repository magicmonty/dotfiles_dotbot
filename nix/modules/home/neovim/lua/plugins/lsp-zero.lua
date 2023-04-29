return {
  {
    -- LSP Configuration & Plugins
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      'nightfox',
      'neovim/nvim-lspconfig',
      'folke/neodev.nvim',
      'b0o/SchemaStore.nvim',

      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        cmd = { 'LspInstall', 'LspUninstall' },
      },

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lua',
      'ray-x/cmp-treesitter',
      { 'dcampos/cmp-emmet-vim', dependencies = 'mattn/emmet-vim' },

      -- snippets
      'luasnip',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- LSP colorscheme
      'onsails/lspkind-nvim',
      { 'folke/lsp-colors.nvim', dependencies = 'nightfox' },

      -- UI
      'folke/trouble.nvim',
      'glepnir/lspsaga.nvim',

      'windwp/nvim-autopairs',

      -- Inc rename
      'smjonas/inc-rename.nvim',

      -- Formatters and Linters,
      'jose-elias-alvarez/null-ls.nvim',
      'jay-babu/mason-null-ls.nvim',
    },
    config = function()
      local lsp = require('lsp-zero')

      -- Set recommended settings
      lsp.preset('recommended')

      -- Configure some indiviual settings for differen plugins
      -- This must be set up before running lsp.preset
      require('magicmonty.config.mason').configure()
      require('magicmonty.config.lspsaga').configure()
      require('magicmonty.config.trouble').configure()
      require('magicmonty.config.lspkind').configure()

      -- ensure that these LSP servers are installed
      lsp.ensure_installed({
        'eslint',
        'html',
        'jsonls',
        'omnisharp',
        'lua_ls',
        -- 'solargraph',
        'marksman',
        'tsserver',
      })

      -- Make the Lua LSP server aware of the vim runtime paths
      lsp.nvim_workspace()

      local icons = require('magicmonty.icons').diagnostics
      lsp.set_preferences({
        suggest_lsp_servers = true,
        sign_icons = {
          error = icons.Error,
          warn = icons.Warning,
          hint = icons.Hint,
          info = icons.Information,
        },
      })

      -- setup CMP
      local cmp_config = require('magicmonty.config.cmp')

      lsp.setup_nvim_cmp(cmp_config.get_options())
      require('cmp').setup({ sorting = cmp_config.get_sorting() })

      -- LSP settings.
      lsp.on_attach(function(client, bufnr)
        --[[ if client.name == 'eslint' then
          vim.cmd.LspStop('eslint')
          return
        end ]]

        local mappings = require('magicmonty.config.lsp.mappings')
        mappings.set_mappings(client, bufnr)
        mappings.setup_formatting(client, bufnr)
      end)

      -- configure some LSP servers
      lsp.configure('jsonls', require('magicmonty.config.lsp.jsonls').opts)
      lsp.configure('solargraph', require('magicmonty.config.lsp.solargraph').opts)
      lsp.configure('pylsp', require('magicmonty.config.lsp.pylsp').opts)
      lsp.configure('marksman', require('magicmonty.config.lsp.marksman').opts)
      lsp.configure('omnisharp', require('magicmonty.config.lsp.omnisharp').opts)
      lsp.configure('texlab', require('magicmonty.config.lsp.texlab').opts)

      lsp.format_on_save({
        format_opts = {
          timeout_ms = 10000,
        },
        servers = {
          ['null-ls'] = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'json', 'lua' },
        },
      })

      require('neodev').setup({})

      local null_ls = require('null-ls')
      local null_opts = lsp.build_options('null-ls', {})

      lsp.setup()

      local mason_null_ls = require('mason-null-ls')
      mason_null_ls.setup({
        ensure_installed = { 'stylua', 'prettierd', 'eslint_d' },
        automatic_installation = true,
        automatic_setup = true,
        handlers = {},
      })

      null_ls.setup({
        border = 'rounded',
        on_attach = function(client, buffer)
          null_opts.on_attach(client, buffer)
        end,
      })

      require('magicmonty.config.diagnostics').configure()

      -- Turn on lsp status information
      require('fidget').setup({ text = { spinner = 'moon' } })

      -- lsp colors
      require('magicmonty.config.lsp-colors').configure()

      -- LSP Enable diagnostics
      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
          prefix = '»',
          severity_limit = 'Warning',
          spacing = 4,
        },
        underline = true,
        signs = true,
        update_in_insert = false,
      })

      local pop_opts = { border = 'rounded', max_width = 80 }
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)
    end,
  },
}
