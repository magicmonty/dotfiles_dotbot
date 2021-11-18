-- vim: foldlevel=99:
local status, saga = pcall(require, "lspsaga")
if (not status) then return end

local map = require('vim_ext').map

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

-- Mappings
local silent = { silent = true, noremap = true }
map('n', '<M-End>', ':Lspsaga diagnostic_jump_next<cr>', silent)
map('n', '<S-M-Right>', ':Lspsaga diagnostic_jump_next<cr>', silent)
map('n', '<M-Home>', ':Lspsaga diagnostic_jump_prev<cr>', silent)
map('n', '<S-M-Left>', ':Lspsaga diagnostic_jump_prev<cr>', silent)
map('n', 'k', ':Lspsaga hover_doc<cr>', silent)
map('n', '<leader>gs', ':Lspsaga signature_help<cr>', silent)
map('n', '<leader>gh', ':Lspsaga lsp_finder<cr>', silent)
map('n', '<leader>gr', ':Lspsaga rename<cr>', silent)
map('n', '<C-r><C-r>', ':Lspsaga rename<cr>', silent)
map('n', '<leader>ca', ':Lspsaga code_action<cr>', silent)
map('n', '<C-.>', ':Lspsaga code_action<cr>', { silent = true })
map('v', '<leader>ca', ':<C-u>Lspsaga range_code_action<cr>', silent)

