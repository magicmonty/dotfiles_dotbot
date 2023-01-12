local M = {}

M.setup = function()
  local icons = require('magicmonty.icons').diagnostics

  -- LSPSaga Configuration
  require('lspsaga').init_lsp_saga({
    border_style = 'rounded',
    saga_winblend = 5,
    diagnostic_header = { icons.Error, icons.Warning, icons.Information, icons.Hint },
    code_action_icon = icons.CodeAction .. ' ',
    finder_request_timeout = 3000,
    finder_action_keys = {
      open = { 'o', '<CR>' },
      vsplit = 'v',
      split = 's',
      tabe = 't',
      quit = { 'q', '<Esc>' }
    },
    code_action_keys = {
      quit = '<Esc>',
      exec = '<CR>',
    },
    rename_action_quit = '<Esc>',
    server_filetype_map = {}
  })
end

return M
