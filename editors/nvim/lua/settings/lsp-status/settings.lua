local nvim_status = require('lsp-status')
local icons = require('icons').diagnostics

local status = {}

status.select_symbol = function(cursor_pos, symbol)
  if symbol.valueRange then
    local value_range = {
      ['start'] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[1]),
      },
      ['end'] = {
        character = 0,
        line = vim.fn.byte2line(symbol.valueRange[2]),
      },
    }

    return require('lsp-status.util').in_range(cursor_pos, value_range)
  end
end

status.activate = function()
  nvim_status.config({
    status_symbol = '',
    select_symbol = status.select_symbol,
    indicator_errors = icons.Error,
    indicator_warnings = icons.Warning,
    indicator_info = icons.Information,
    indicator_hint = icons.Hint,
  })

  nvim_status.register_progress()
end

return status
