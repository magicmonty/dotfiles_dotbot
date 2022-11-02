local status, dap = pcall(require, 'dap')
if not status then
  return
end

local map = vim.keymap.set

vim.api.nvim_create_user_command('DapUiToggle', require('dapui').toggle, { force = true })
vim.api.nvim_create_user_command('DapUiOpen', require('dapui').open, { force = true })
vim.api.nvim_create_user_command('DapUiClose', require('dapui').close, { force = true })

vim.fn.sign_define(
  'DapBreakpoint',
  { text = '', texthl = 'DapBreakpointSign', linehl = 'DapBreakpointLine', numhl = '' }
)
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointSign', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })

local opts = { silent = true, noremap = true, buffer = 0 }

map('n', '<F5>', function()
  dap.continue()
end, opts)

map('n', '<F9>', function()
  dap.toggle_breakpoint()
end, opts)

map('n', '<F10>', function()
  dap.step_over()
end, opts)

map('n', '<F11>', function()
  dap.step_into()
end, opts)

map('n', '<S-F11>', function()
  dap.step_out()
end, opts)

map('n', '<leader>dq', function()
  require('dapui').close()
end, opts)

map('n', '<leader>do', function()
  require('dapui').open()
end, opts)

map('n', '<leader>db', ':Telescope dap list_breakpoints<cr>', opts)
map('n', '<leader>dv', ':Telescope dap variables<cr>', opts)
