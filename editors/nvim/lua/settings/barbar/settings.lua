local map = vim.keymap.set
local silent = { silent = true, remap = false }

-- Buffer navigation with leader key
map('n', '<leader>bk', '<cmd>BufferNext<cr>', silent)
map('n', '<leader>bmk', '<cmd>BufferMoveNext<cr>', silent)
map('n', '<leader>bj', '<cmd>BufferPrevious<cr>', silent)
map('n', '<leader>bmj', '<cmd>BufferMovePrevious<cr>', silent)
map('n', '<leader>bd', '<cmd>BufferClose<cr>', silent)
map('n', '<leader>bD', '<cmd>BufferCloseAllButCurrent<cr>', silent)
map('n', '<leader>bP', '<cmd>BufferCloseAllButPinned<cr>', silent)
map('n', '<leader>bg', '<cmd>BufferPick<cr>', silent)
map('n', '<leader>bp', '<cmd>BufferPin<cr>', silent)

map('n', '<leader>b1', '<cmd>BufferGoto 1<cr>', silent)
map('n', '<leader>b2', '<cmd>BufferGoto 2<cr>', silent)
map('n', '<leader>b3', '<cmd>BufferGoto 3<cr>', silent)
map('n', '<leader>b4', '<cmd>BufferGoto 4<cr>', silent)
map('n', '<leader>b5', '<cmd>BufferGoto 5<cr>', silent)
map('n', '<leader>b6', '<cmd>BufferGoto 6<cr>', silent)
map('n', '<leader>b7', '<cmd>BufferGoto 7<cr>', silent)
map('n', '<leader>b8', '<cmd>BufferGoto 8<cr>', silent)
map('n', '<leader>b9', '<cmd>BufferGoto 9<cr>', silent)

map('n', '<leader>Tc', '<cmd>tabnew<cr>', silent)
map('n', '<leader>Tn', '<cmd>tabnext<cr>', silent)
map('n', '<leader>Tp', '<cmd>tabprev<cr>', silent)
