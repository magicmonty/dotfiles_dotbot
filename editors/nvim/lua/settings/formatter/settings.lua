local formatters = require('magicmonty.formatters')

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

vim.api.nvim_create_augroup('AutoFormatFiles', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'AutoFormatFiles',
  pattern = '*.js,*.ts,*.tsx,*.jsx,*.html,*.css,*.scss,*.lua',
  command = 'FormatWrite',
})
