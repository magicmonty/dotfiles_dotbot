local icons = require('icons')

require('notify').setup({
  timeout = 3000,
  stages = 'fade',
  icons = {
    ERROR = icons.diagnostics.Error,
    WARN = icons.diagnostics.Warning,
    INFO = icons.diagnostics.Information,
    DEBUG = icons.diagnostics.Debug,
    TRACE = icons.diagnostics.Trace,
  },
  background_colour = require('nightfox.colors').init().bg,
})

