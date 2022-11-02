local prettier = require('formatter.filetypes.javascript').prettiereslint

require('formatter').setup({
  filetype = {
    javascript = { prettier },
    typescript = { prettier },
    javascriptreact = { prettier },
    typescriptreact = { prettier },
    html = { prettier },
    css = { prettier },
    scss = { prettier },
    lua = { require('formatter.filetypes.lua').stylua },
    latex = { require('formatter.filetypes.latex').latexindent },
  },
})

-- vim.api.nvim_create_augroup('AutoFormatFiles', { clear = true })
--[[ vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'AutoFormatFiles',
  pattern = '*.js,*.ts,*.tsx,*.jsx,*.html,*.css,*.scss,*.lua',
  command = 'FormatWrite',
}) ]]
