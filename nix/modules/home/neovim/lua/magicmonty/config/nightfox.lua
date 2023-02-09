local M = {}

M.colors = {}

M.configure = function()
  local installed, nightfox = pcall(require, 'nightfox')
  if not installed then return end

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
      }
    }
  })

  vim.cmd [[colorscheme nightfox]]

  M.colors = require('nightfox.spec').load('nightfox')

  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = M.colors.error })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = M.colors.info })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = M.colors.info })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = M.colors.warn })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = M.colors.hint })
end

return M
