local au = require("vim_ext").au
local augroup = require("vim_ext").augroup
local opt = vim.opt

augroup("FileTypeOverrides", {
  {'BufNewFile,BufRead', '*.md', 'setfiletype markdown'},
  {'BufNewFile,BufRead', '*.build', 'setfiletype xml'},
  {'BufNewFile,BufRead', '*.targets', 'setfiletype xml'},
  {'BufNewFile,BufRead', '*.nunit', 'setfiletype xml'},
  {'BufNewFile,BufRead', '*.config', 'setfiletype xml'},
  {'BufNewFile,BufRead', '*.xaml', 'setfiletype xml'},
  {'BufNewFile,BufRead', '*.DotSettings', 'setfiletype xml'},
})

opt.suffixesadd = ".js,.json,.css,.less,.sass,.py,.md,.cs"
au({"FileType", "ruby", "setlocal shiftwidth=2 tabstop=2"})
au({"FileType", "csharp", "setlocal shiftwidth=2 tabstop=2"})
au({"FileType", "yaml", "setlocal shiftwidth=2 tabstop=2"})
au({"FocusLost", "*", "silent! :wa"})

-- vim: foldlevel=99:
