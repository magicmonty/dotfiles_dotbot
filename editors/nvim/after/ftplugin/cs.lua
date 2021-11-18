local status, dap = pcall(require, 'dap')
if not status then return end

require("dapui").setup()
vim.cmd [[
  command! DapUiToggle lua require('dapui').toggle()
  command! DapUiOpen lua require('dapui').open()
  command! DapUiClose lua require('dapui').close()
]]

local map = require('vim_ext').map

vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpointSign', linehl='DapBreakpointLine', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointSign', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='', linehl='', numhl=''})


vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<F5>', ':lua require"dap".continue()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<F9>', ':lua require"dap".toggle_breakpoint()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<F10>', ':lua require"dap".step_over()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<F11>', ':lua require"dap".step_into()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<S-F11>', ':lua require"dap".step_out()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<leader>dq', ':lua require"dapui".close()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<leader>do', ':lua require"dapui".open()<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<leader>db', ':Telescope dap list_breakpoints<cr>', { silent = true, noremap = true })
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<leader>dv', ':Telescope dap variables<cr>', { silent = true, noremap = true })
