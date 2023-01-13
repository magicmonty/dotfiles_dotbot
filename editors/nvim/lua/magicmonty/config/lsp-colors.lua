M = {}

M.configure = function()
  local colors = require('magicmonty.theme').colors.diag
  require('lsp-colors').setup({
    Error = colors.error,
    Warning = colors.warn,
    Information = colors.info,
    Hint = colors.hint
  })
end

return M
