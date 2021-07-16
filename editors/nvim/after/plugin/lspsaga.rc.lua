-- vim: foldlevel=99:
local status, saga = pcall(require, "lspsaga")
if (not status) then return end

local map = require('vim_ext').map

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

-- Mappings
local silent = { silent = true }
map('n', '<C-j>', ':Lspsaga diagnostic_jump_next<cr>', silent)
map('n', 'K', ':Lspsaga hover_doc<cr>', silent)
map('i', '<C-K>', ':Lspsaga signature_help<cr>', silent)
map('n', '<leader>gh', ':Lspsaga lsp_finder<cr>', silent)
