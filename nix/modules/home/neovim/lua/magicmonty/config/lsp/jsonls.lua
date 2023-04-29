local M = {}

M.opts = {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.lin('$'), 0 })
      end,
    },
  },
  settings = {
    json = {
      schemaDownload = { enable = true },
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

return M
