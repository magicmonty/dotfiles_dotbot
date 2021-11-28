local status, notify = pcall(require, 'notify')
if not status then
  return
end

notify.setup({
  timeout = 3000,
  stages = 'fade',
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
  background_colour = require('nightfox.colors').init().bg,
})

local log = require('plenary.log').new({
  plugin = 'notify',
  level = 'debug',
  use_console = false,
})

vim.notify = function(msg, level, opts)
  log.info(msg, level, opts)
  require('notify')(msg, level, opts)
end
