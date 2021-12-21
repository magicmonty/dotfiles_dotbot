-- vim: foldlevel=99:
local lspcolors = require('lsp-colors')
local icons = require('icons')
local c = require('nightfox.colors').init()

-- Setting LSP colors to the NightFox color theme
lspcolors.setup({
  Error = c.red,
  Warning = c.orange,
  Information = c.cyan_dm,
  Hint = c.green_dm,
})

-- LSP signs default
vim.fn.sign_define(
  'DiagnosticSignError',
  { texthl = 'DiagnosticSignError', text = icons.diagnostics.Error, numhl = 'DiagnosticSignError' }
)

vim.fn.sign_define(
  'DiagnosticSignWarn',
  { texthl = 'DiagnosticSignWarn', text = icons.diagnostics.Warning, numhl = 'DiagnosticSignWarn' }
)

vim.fn.sign_define(
  'DiagnosticSignHint',
  { texthl = 'DiagnosticSignHint', text = icons.diagnostics.Hint, numhl = 'DiagnosticSignHint' }
)

vim.fn.sign_define(
  'DiagnosticSignInfo',
  { texthl = 'DiagnosticSignInfo', text = icons.diagnostics.Information, numhl = 'DiagnosticSignInformation' }
)
