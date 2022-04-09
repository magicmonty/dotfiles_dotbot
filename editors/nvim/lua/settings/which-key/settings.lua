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
    d = 'Close buffer',
    D = 'Close all buffers but current',
    P = 'Close all buffers but pinned',
    k = 'Next buffer',
    j = 'Previous buffer',
    g = 'Pick buffer',
    p = 'Pin buffer',
    m = {
      name = 'Move buffer',
      k = 'Move tab to the right',
      j = 'Move tab to the left',
    },
    ['1'] = 'Switch to buffer 1',
    ['2'] = 'Switch to buffer 2',
    ['3'] = 'Switch to buffer 3',
    ['4'] = 'Switch to buffer 4',
    ['5'] = 'Switch to buffer 5',
    ['6'] = 'Switch to buffer 6',
    ['7'] = 'Switch to buffer 7',
    ['8'] = 'Switch to buffer 8',
    ['9'] = 'Switch to buffer 9',
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
    o = 'Old files (history)',
    p = 'Find project',
    w = 'Find word under cursor',
    W = 'Find exact word under cursor',
  },
  g = {
    name = 'Git',
    s = 'Git status',
    d = {
      name = 'Git diff',
      n = 'Next hunk',
      p = 'Previous hunk',
    },
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
  n = {
    name = 'New',
    f = 'New file',
  },
  -- o = {
  -- name = 'Orgmode',
  -- a = 'Agenda',
  -- c = 'Quick capture',
  -- },
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
