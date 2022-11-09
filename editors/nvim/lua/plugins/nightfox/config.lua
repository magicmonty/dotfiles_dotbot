local nightfox = require('nightfox')
local opt = vim.opt
local augroup = require('vim_ext').augroup

nightfox.setup({
  options = {
    transparent = false,
    alt_nc = true,
    terminal_colors = true,
    styles = {
      comments = 'italic',
      keywords = 'bold',
    },
    inverse = {
      visual = false,
    },
  },
  groups = {
    all = {
      IndentBlanklineChar = { fg = 'syntax.comment' },
      IndentBlanklineContextChar = { fg = 'palette.pink' },
      IndentBlanklineSpaceChar = { fg = 'syntax.comment' },
      IndentBlanklineSpaceCharBlankLine = { fg = 'NONE' },
      DapBreakpointSign = { fg = 'palette.red' },
      DebugBreakpointSign = { fg = 'palette.red' },
      DapBreakpointLine = { bg = 'diff.delete' },
      DebugBreakpointLine = { bg = 'diff.delete' },
      TSTag = { fg = 'palette.red' },
      TSTagDelimiter = { fg = 'fg0' },
      htmlTag = { fg = 'palette.red' },
      htmlEndTag = { fg = 'palette.red' },
      NvimTreeExecFile = { style = 'bold' },
      NvimTreeGitDirty = { fg = 'git.changed' },
      NvimTreeGitStaged = { fg = 'palette.green.bright' },
      NvimTreeGitMerge = { fg = 'palette.orange' },
      NvimTreeGitRenamed = { fg = 'palette.green.dim' },
      NvimTreeGitNew = { fg = 'git.add' },
      NvimTreeGitDeleted = { fg = 'git.removed' },
      VimwikiWeblink1 = { fg = 'palette.cyan', style = 'underline' },
      VimwikiCellSeparator = { fg = 'palette.magenta' },
    }
  },
})

local theme = require('magicmonty.theme')
vim.cmd('colorscheme ' .. theme.colorscheme)

---@diagnostic disable-next-line: assign-type-mismatch
opt.list = true
opt.listchars:append('space:⋅')
opt.listchars:append('eol:↴')

---@diagnostic disable-next-line: assign-type-mismatch
opt.colorcolumn = '120'
---@diagnostic disable-next-line: assign-type-mismatch
opt.cursorline = true
augroup('BgHighlight', {
  { 'WinEnter', '*', 'setlocal cursorline' },
  { 'WinLeave', '*', 'setlocal nocursorline' },
})

---@diagnostic disable-next-line: assign-type-mismatch
opt.background = 'dark'

require('indent_blankline').setup({
  show_end_of_line = true,
  space_char_blank_line = ' ',
  show_current_context = true,
  show_current_context_start = true,
})

-- Undercurl support
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

-- No background color erase
vim.cmd [[let &t_ut = '']]

local colors = require('magicmonty.theme').colors.diag
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.error })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.info })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.info })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = colors.warn })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = colors.hint })
