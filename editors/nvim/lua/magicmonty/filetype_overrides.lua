local mappings = {
  md = 'markdown',
  build = 'xml',
  targets = 'xml',
  nunit = 'xml',
  config = 'xml',
  xaml = 'xml',
  DotSettings = 'xml',
}

local fileTypeOverrides = Augroup('FileTypeOverrides', { clear = true })
for extension, file_type in pairs(mappings) do
  Autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = '*.' .. extension,
    command = 'setfiletype ' .. file_type,
    group = fileTypeOverrides,
  })
end

vim.opt.suffixesadd = '.js,.json,.css,.less,.sass,.scss,.py,.md,.cs'
Autocmd('FileType', {
  pattern = { 'ruby', 'csharp', 'yaml' },
  command = 'setlocal shiftwidth=2 tabstop=2',
  group = fileTypeOverrides
})
