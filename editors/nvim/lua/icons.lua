local M = {}

M.diagnostics = {
  Error = '',
  Warning = '',
  Information = '',
  Hint = '',
  CodeAction = '',
  Debug = '',
  Trace = '✎',
  Ok = '',
}

M.git = {
  added = '',
  modified = '',
  removed = '',
}

M.spinner = {
  frames = {
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  },
}
return M
