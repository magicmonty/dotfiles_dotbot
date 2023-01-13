local M = {}

M.configure = function()
  local icons = require('magicmonty.icons').diagnostics
  local sign_define = vim.fn.sign_define

  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true
  })

  --
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
end

return M
