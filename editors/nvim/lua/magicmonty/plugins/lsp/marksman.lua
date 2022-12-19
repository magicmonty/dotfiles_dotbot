local M = {}

M.opts = {
  filetypes = { 'markdown' },
  root_dir = require('lspconfig.util').root_pattern('.git', '.marksman.toml', 'README.md', 'index.md')
}

return M
