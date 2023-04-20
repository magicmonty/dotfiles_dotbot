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

M.todo = {
  Fix = " ",
  Todo = " ",
  Hack = " ",
  Warn = " ",
  Perf = " ",
  Note = " ",
  Test = "⏲ ",
}

M.git = {
  added = '',
  modified = '',
  removed = '',
  branch = '',
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
