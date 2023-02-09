local M = {}

M.colors = {}

M.configure = function()
  local nightfox = require('magicmonty.config.nightfox')
  nightfox.configure()
  M.colors = nightfox.colors

  vim.opt.list = true
  vim.opt.listchars:append('space:⋅')
  vim.opt.listchars:append('eol:↴')
  vim.opt.colorcolumn = '120'
  vim.opt.cursorline = true
  vim.opt.background = 'dark'

  local bgHighlight = Augroup('BgHighlight', { clear = true })
  Autocmd('WinEnter', { pattern = '*', group = bgHighlight, command = 'setlocal cursorline' })
  Autocmd('WinLeave', { pattern = '*', group = bgHighlight, command = 'setlocal nocursorline' })

  -- Undercurl support
  vim.cmd [[let &t_Cs = "\e[4:3m"]]
  vim.cmd [[let &t_Ce = "\e[4:0m"]]

  -- No background color erase
  vim.cmd [[let &t_ut = '']]
end

M.icons = require('magicmonty.icons')

return M
