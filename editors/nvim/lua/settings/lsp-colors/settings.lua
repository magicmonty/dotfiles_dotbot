-- vim: foldlevel=99:
local lspcolors = require('lsp-colors')
local icons = require('icons').diagnostics
local nightfox = require('nightfox.pallet.nightfox')
local colors = nightfox.generate_spec(nightfox.pallet)

-- Setting LSP colors to the NightFox color theme
lspcolors.setup({
  Error = colors.diag.error,
  Warning = colors.diag.warn,
  Information = colors.diag.info,
  Hint = colors.diag.hint,
})

-- LSP signs default
vim.fn.sign_define(
  'DiagnosticSignError',
  { texthl = 'DiagnosticSignError', text = icons.Error, numhl = 'DiagnosticSignError' }
)

vim.fn.sign_define(
  'DiagnosticSignWarn',
  { texthl = 'DiagnosticSignWarn', text = icons.Warning, numhl = 'DiagnosticSignWarn' }
)

vim.fn.sign_define(
  'DiagnosticSignHint',
  { texthl = 'DiagnosticSignHint', text = icons.Hint, numhl = 'DiagnosticSignHint' }
)

vim.fn.sign_define(
  'DiagnosticSignInfo',
  { texthl = 'DiagnosticSignInfo', text = icons.Information, numhl = 'DiagnosticSignInformation' }
)
