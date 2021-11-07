vim.g.neoterm_default_mod = 'vertical'
vim.g.neoterm_autoscroll = true
vim.g.neoterm_autoinsert = true

local map = require("vim_ext").map
local au = require("vim_ext").au

map('n', '<C-y>', ':Ttoggle<cr>', {silent = true, noremap = true})
map('n', '<C-y>', '<Esc>:Ttoggle<cr>', {silent = true, noremap = true})
map('t', '<C-y>', '<C-\\><C-n>:Ttoggle<cr>', {silent = true, noremap = true})
au({'TermOpen', '*', 'tnoremap <Esc> <C-\\><C-n>'})
