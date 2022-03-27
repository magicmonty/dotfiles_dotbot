local map = vim.keymap.set
local silent = { silent = true }

require('tabline').setup({ options = { show_filename_only = true } })

-- Buffer navigation with leader key
map('n', '<leader>bn', '<cmd>TablineBufferNext<cr>', silent)
map('n', '<leader>bp', '<cmd>TablineBufferPrevious<cr>', silent)
map('n', '<leader>bd', ':bd<cr>', silent)

-- map('n', '<leader>bn', ':bn<cr>', silent)
-- map('n', '<leader>bp', ':bp<cr>', silent)

map('n', '<leader>Tc', '<cmd>TablineTabNew<cr>', silent)
map('n', '<leader>Tn', '<cmd>tabnext<cr>', silent)
map('n', '<leader>Tp', '<cmd>tabprev<cr>', silent)
map('n', '<leader>Tb', '<cmd>TablineToggleShowAllBuffers<cr>', silent)
map('n', '<leader>Tr', '<cmd>TablineTabRename ', { noremap = true })
