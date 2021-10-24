local cmd = vim.cmd
local opt = vim.opt

if opt.termguicolors and opt.winblend then
  cmd 'syntax enable'
  opt.termguicolors = true
  opt.winblend = 0
  opt.wildoptions = { 'pum' }
  opt.pumblend = 5
  opt.background = "dark"
  -- vim.g.palenight_terminal_italics = 1
  -- cmd([[
  --   try
  --     colorscheme palenight
  --   catch /^Vim\%((\a\+)\)\=:E185/
  --     colorscheme default
  --     set background=dark
  --   endtry
  -- ]])
end

