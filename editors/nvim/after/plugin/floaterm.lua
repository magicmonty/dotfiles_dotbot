if not vim.g.plugs['vim-floaterm'] then return end

local map = require("vim_ext").map

vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8
vim.g.floaterm_position = "center"
vim.g.floaterm_autoclose = 1
vim.g.floaterm_autoinsert = 1

map('n', '<leader>tt', ':FloatermToggle<cr>', {silent = true, noremap = true})
map('n', '<leader>tg', ':FloatermNew lazygit<cr>', {silent = true, noremap = true})
map('n', '<leader>tv', ':FloatermNew --wintype=vsplit --width=0.5<cr>', {silent = true, noremap = true})
map('n', '<leader>th', ':FloatermNew --wintype=split --height=0.5<cr>', {silent = true, noremap = true})
map('n', '<leader>tq', ':FloatermKill<cr>', {silent = true, noremap = true})
map('n', '<C-y>', ':FloatermToggle<cr>', {silent = true, noremap = true})
map('n', '<C-Y>', ':FloatermToggle<cr>', {silent = true, noremap = true})
map('i', '<C-y>', '<Esc>:FloatermToggle<cr>', {silent = true, noremap = true})
map('t', '<C-y>', '<C-\\><C-n>:FloatermToggle<cr>', {silent = true, noremap = true})
map('t', '<C-q>', '<C-\\><C-n>:FloatermKill<cr>', {silent = true, noremap = true})

-- vim: foldlevel=99
