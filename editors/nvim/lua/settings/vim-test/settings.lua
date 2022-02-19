local map = require('vim_ext').map

map('n', '<leader>rt', ':Ultest<cr>', { silent = true, noremap = true })
map('n', '<leader>rl', ':UltestLast<cr>', { silent = true, noremap = true })
map('n', '<leader>st', ':UltestSummary<cr>', { silent = true, noremap = true })
vim.cmd([[
  let test#strategy = "floaterm"
  let g:test#csharp#runner = "dotnettest"
  let g:ultest_use_pty = 1
  ]])
