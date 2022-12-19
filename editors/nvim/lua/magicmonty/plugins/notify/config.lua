local installed, notify = pcall(require, 'notify')
if not installed then return end

local theme = require('magicmonty.theme')
local icons = theme.icons.diagnostics

notify.setup({
  timeout = 3000,
  stages = 'fade',
  icons = {
    ERROR = icons.Error,
    WARN = icons.Warning,
    INFO = icons.Information,
    DEBUG = icons.Debug,
    TRACE = icons.Trace,
  },
  background_colour = theme.colors.bg0,
})

vim.notify = require('notify')

