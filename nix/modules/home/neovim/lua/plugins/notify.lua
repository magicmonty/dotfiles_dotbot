-- Nice notification windows
return {
  'rcarriga/nvim-notify',
  dependencies = { 'nightfox' },
  config = function()
    local theme = require('magicmonty.theme')
    local icons = theme.icons.diagnostics

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
      background_colour = theme.colors.bg0,
    })

    vim.notify = require('notify')
  end,
}
