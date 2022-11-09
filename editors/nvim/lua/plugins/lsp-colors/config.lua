-- vim: foldlevel=99:
local lspcolors = require('lsp-colors')
local theme = require('magicmonty.theme')
local icons = theme.icons.diagnostics
local colors = theme.colors.diag
local sign_define = vim.fn.sign_define

-- Setting LSP colors to the NightFox color theme
lspcolors.setup({
  Error = colors.error,
  Warning = colors.warn,
  Information = colors.info,
  Hint = colors.hint,
})

-- LSP signs default
sign_define(
  'DiagnosticSignError',
  { texthl = 'DiagnosticSignError', text = icons.Error, numhl = 'DiagnosticSignError' }
)

sign_define(
  'DiagnosticSignWarn',
  { texthl = 'DiagnosticSignWarn', text = icons.Warning, numhl = 'DiagnosticSignWarn' }
)

sign_define(
  'DiagnosticSignHint',
  { texthl = 'DiagnosticSignHint', text = icons.Hint, numhl = 'DiagnosticSignHint' }
)

sign_define(
  'DiagnosticSignInfo',
  { texthl = 'DiagnosticSignInfo', text = icons.Information, numhl = 'DiagnosticSignInformation' }
)
