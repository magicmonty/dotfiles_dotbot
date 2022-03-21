local icons = require('icons').diagnostics

require('notify').setup({
  timeout = 3000,
  stages = 'fade',
  icons = {
    ERROR = icons.Error,
    WARN = icons.Warning,
    INFO = icons.Information,
    DEBUG = icons.Debug,
    TRACE = icons.Trace,
  },
  background_colour = require('nightfox.pallet.nightfox').pallet.bg0,
})

