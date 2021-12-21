local formatter = require('formatter')

local formatters = require('magicmonty.formatters')
local augroup = require('vim_ext').augroup
local au = require('vim_ext').au

require('formatter').setup({
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
