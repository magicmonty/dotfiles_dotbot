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
  },
})

local theme = require('magicmonty.theme')
vim.cmd('colorscheme ' .. theme.colorscheme)

opt.list = true
opt.listchars:append('space:⋅')
opt.listchars:append('eol:↴')

opt.colorcolumn = '120'
opt.cursorline = true
augroup('BgHighlight', {
  { 'WinEnter', '*', 'setlocal cursorline' },
  { 'WinLeave', '*', 'setlocal nocursorline' },
})

opt.background = 'dark'

require('indent_blankline').setup({
  show_end_of_line = true,
  space_char_blank_line = ' ',
  show_current_context = true,
  show_current_context_start = true,
})
