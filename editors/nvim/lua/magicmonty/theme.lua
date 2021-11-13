local cmd = vim.cmd
local opt = vim.opt

if opt.termguicolors and opt.winblend then
  cmd 'syntax enable'
  opt.termguicolors = true
  opt.winblend = 0
  opt.wildoptions = { 'pum' }
  opt.pumblend = 5
  opt.background = "dark"
end

