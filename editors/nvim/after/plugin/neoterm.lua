vim.g.neoterm_default_mod = 'belowright'
vim.g.neoterm_autoscroll = true
vim.g.neoterm_autoinsert = true

local map = require("vim_ext").map
local au = require("vim_ext").au

map('n', '<C-y>', ':Ttoggle<cr>', {silent = true, noremap = true})
map('n', '<C-Y>', ':Ttoggle<cr>', {silent = true, noremap = true})
map('n', '<C-y>', '<Esc>:Ttoggle<cr>', {silent = true, noremap = true})
map('t', '<C-y>', '<C-\\><C-n>:Ttoggle<cr>', {silent = true, noremap = true})
map('t', '<C-w>h', '<C-\\><C-n><C-w>h')
map('t', '<C-w><Left>', '<C-\\><C-n><C-w>h')
map('t', '<C-w>l', '<C-\\><C-n><C-w>l')
map('t', '<C-w><Right>', '<C-\\><C-n><C-w>l')
map('t', '<C-w>j', '<C-\\><C-n><C-w>j')
map('t', '<C-w><Down>', '<C-\\><C-n><C-w>j')
map('t', '<C-w>k', '<C-\\><C-n><C-w>k')
map('t', '<C-w><Up>', '<C-\\><C-n><C-w>k')
au({'TermOpen', '*', 'tnoremap <Esc> <C-\\><C-n>'})
au({'BufEnter', '*', "if &buftype == 'terminal' | :startinsert | endif"})
