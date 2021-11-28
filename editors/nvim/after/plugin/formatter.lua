local status, formatter = pcall(require, 'formatter')
if not status then
  return
end

local formatters = require('magicmonty.formatters')
local augroup = require('vim_ext').augroup
local au = require('vim_ext').au

formatter.setup({
  filetype = {
    javascript = { formatters.prettier },
    typescript = { formatters.prettier },
    javascriptreact = { formatters.prettier },
    typescriptreact = { formatters.prettier },
    html = { formatters.prettier },
    css = { formatters.prettier },
    scss = { formatters.prettier },
    lua = { formatters.stylua },
  },
})

augroup('AutoFormatFiles', {
  { 'BufWritePost', '*.js,*.ts,*.jsx,*.tsx,*.html,*.scss,*.css,*.lua', 'FormatWrite' },
})
