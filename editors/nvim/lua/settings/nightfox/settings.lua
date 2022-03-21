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
    groups = {
      IndentBlanklineChar = { fg = '${comment}' },
      IndentBlanklineContextChar = { fg = '${pink}' },
      IndentBlanklineSpaceChar = { fg = '${comment}' },
      IndentBlanklineSpaceCharBlankLine = { fg = 'NONE' },
      DapBreakpointSign = { fg = '${red}' },
      DebugBreakpointSign = { fg = '${red}' },
      DapBreakpointLine = { bg = '${diff.delete}' },
      DebugBreakpointLine = { bg = '${diff.delete}' },
      TSTag = { fg = '${red}' },
      TSTagDelimiter = { fg = '${fg}' },
      htmlTag = { fg = '${red}' },
      htmlEndTag = { fg = '${red}' },
      NvimTreeExecFile = { style = 'bold' },
      NvimTreeGitDirty = { fg = '${git.change}' },
      NvimTreeGitStaged = { fg = '${green_br}' },
      NvimTreeGitMerge = { fg = '${orange}' },
      NvimTreeGitRenamed = { fg = '${green_dm}' },
      NvimTreeGitNew = { fg = '${git.add}' },
      NvimTreeGitDeleted = { fg = '${git.delete}' },
      VimwikiWeblink1 = { fg = '${cyan}', style = 'underline' },
      VimwikiCellSeparator = { fg = '${magenta}' },
    },
  }
})

vim.cmd [[ colorscheme nightfox ]]

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
