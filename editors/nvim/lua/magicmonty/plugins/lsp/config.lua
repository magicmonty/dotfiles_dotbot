local installed, lsp = pcall(require, 'lsp-zero')
if not installed then return end

-- Set recommended settings
lsp.preset('recommended')

-- Configure some indiviual settings for differen plugins
-- This must be set up before running lsp.preset
require('magicmonty.plugins.mason.config').setup()
require('magicmonty.plugins.lspsaga.config').setup()
require('magicmonty.plugins.trouble.config').setup()
require('magicmonty.plugins.lspkind.config').setup()

-- ensure that these LSP servers are installed
lsp.ensure_installed({
  'eslint',
  'html',
  'jsonls',
  'omnisharp',
  'sumneko_lua',
  'solargraph',
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
  }
})

-- setup CMP
local cmp_config = require('magicmonty.plugins.cmp.config')

lsp.setup_nvim_cmp(cmp_config.get_options())
require 'cmp'.setup { sorting = cmp_config.get_sorting(), }

-- LSP settings.
lsp.on_attach(function(client, bufnr)
  if client.name == 'eslint' then
    vim.cmd.LspStop('eslint')
    return
  end

  local mappings = require('magicmonty.plugins.lsp.mappings')
  mappings.set_mappings(client, bufnr)
  mappings.setup_formatting(client, bufnr)
end)

-- configure some LSP servers
lsp.configure('jsonls', require('magicmonty.plugins.lsp.jsonls').opts)
lsp.configure('solargraph', require('magicmonty.plugins.lsp.solargraph').opts)
lsp.configure('pylsp', require('magicmonty.plugins.lsp.pylsp').opts)
lsp.configure('marksman', require('magicmonty.plugins.lsp.marksman').opts)
lsp.configure('omnisharp', require('magicmonty.plugins.lsp.omnisharp').opts)
lsp.configure('texlab', require('magicmonty.plugins.lsp.texlab').opts)

lsp.setup()

require('magicmonty.plugins.diagnostics.config').setup()

-- Turn on lsp status information
require('fidget').setup({ text = { spinner = 'moon' } })

-- lsp colors
require('magicmonty.plugins.lsp-colors.config').setup()

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

-- vim: ts=2 sts=2 sw=2 et
