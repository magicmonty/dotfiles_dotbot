require('which-key').setup({
  plugins = {
    marks = false,
    registers = false,
    spelling = { enabled = false },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  ignore_missing = true,
})

local mappings = {
  ['.'] = 'Toggle file browser',
  ['#'] = 'Comment/Uncomment',
  mm = 'Toggle folding',
  b = {
    name = 'Buffer handling',
    d = 'Delete buffer',
    n = 'Next buffer',
    p = 'Previous buffer',
  },
  c = {
    c = 'Show clipboard',
    d = 'Switch to Zoxide directory',
  },
  d = {
    name = 'Debugger',
    l = 'Run last config',
    q = 'Terminate debugging session',
    r = 'Run debugging session',
    u = 'Toggle Debugger UI',
  },
  en = 'Find in configuration directory',
  f = {
    name = 'Find',
    b = 'Find in current buffer',
    B = 'Find buffer',
    f = 'Find file in current project',
    F = 'Find file in current directory',
    h = 'Find help tag',
    k = 'Find in keymaps',
    lg = 'Live grep',
    m = 'Find marks',
    n = 'Show notification history',
    p = 'Find project',
    w = 'Find word under cursor',
    W = 'Find exact word under cursor',
  },
  h = {
    name = 'Git Hunk',
    b = 'Blame line',
    p = 'Preview hunk',
    r = 'Reset hunk',
    R = 'Reset buffer',
    s = 'Stage hunk',
    S = 'Stage buffer',
    U = 'Reset buffer index',
    u = 'Unstage hunk',
  },
  o = {
    name = 'Orgmode',
    a = 'Agenda',
    c = 'Quick capture',
  },
  q = {
    name = 'Quickfix list',
    n = 'Next entry',
    p = 'Previous entry',
    q = 'Close quickfix list',
  },
  t = {
    name = 'Terminal',
    [','] = 'New Terminal',
    g = 'lazygit window',
    h = 'Open terminal in horizontal split',
    q = 'Close current terminal',
    v = 'Open terminal in vertical split',
  },
  T = {
    name = 'Tabs',
    c = 'New Tab',
    n = 'Next Tab',
    p = 'Previous Tab',
    b = 'Toggle buffer display',
    r = 'Rename Tab',
  },
  w = {
    name = 'Windows',
    o = 'Close other windows/splits',
    s = 'Split horizontally',
    v = 'Split vertically',
  },
}
local opts = {
  prefix = '<leader>',
}

vim.opt.timeoutlen = 100

require('which-key').register(mappings, opts)
