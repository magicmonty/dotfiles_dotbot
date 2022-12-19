require("magicmonty.settings")
require("magicmonty.plugins")
require("magicmonty.remap")
require("magicmonty.highlights")

Augroup = vim.api.nvim_create_augroup
Autocmd = vim.api.nvim_create_autocmd

P = function(v)
  print(vim.inspect(v))
  return v
end

-- Debug Notification
-- (value, context_message)
DN = function(v)
  local time = os.date('%H:%M')
  local msg = time
  vim.notify(vim.inspect(v), 'debug', { title = { 'Debug Output', msg } })
  return v
end

RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

Toggle_FullScreen = function()
  vim.cmd([[ let g:neovide_fullscreen=! g:neovide_fullscreen ]])
end

-- vim: ts=2 sts=2 sw=2 et
