local au = require('vim_ext').au
local augroup = require('vim_ext').augroup
local opt = vim.opt

vim.api.nvim_create_augroup('FileTypeOverrides', { clear = true })

local mappings = {
  md = 'markdown',
  build = 'xml',
  targets = 'xml',
  nunit = 'xml',
  config = 'xml',
  xaml = 'xml',
  DotSettings = 'xml',
}

for extension, file_type in pairs(mappings) do
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.' .. extension,
    command = 'setfiletype ' .. file_type,
    group = 'FileTypeOverrides',
  })
end

opt.suffixesadd = '.js,.json,.css,.less,.sass,.py,.md,.cs'
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'ruby', 'csharp', 'yaml' },
  command = 'setlocal shiftwidth=2 tabstop=2',
  group = 'FileTypeOverrides',
})
vim.api.nvim_create_autocmd('FocusLost', { pattern = '*', command = 'silent! :wa' })

-- vim: foldlevel=99:
