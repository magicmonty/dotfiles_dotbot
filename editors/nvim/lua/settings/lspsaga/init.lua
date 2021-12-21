-- vim: foldlevel=99:
local map = require('vim_ext').map
local icons = require('icons')

require('lspsaga').init_lsp_saga({
  error_sign = icons.diagnostics.Error,
  warn_sign = icons.diagnostics.Warning,
  infor_sign = icons.diagnostics.Information,
  hint_sign = icons.diagnostics.Hint,
  code_action_icon = icons.diagnostics.CodeAction .. ' ',
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 20,
    virtual_text = false,
  },
  border_style = 'round',
  finder_action_keys = {
    quit = '<Esc>',
  },
  code_action_keys = {
    quit = '<Esc>',
  },
  rename_action_keys = {
    quit = '<Esc>',
  },
})
