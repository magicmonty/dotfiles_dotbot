local status, nightfox = pcall(require, "nightfox")
if status then
  nightfox.setup({
    fox = "nightfox",
    transparent = false,
    alt_nc = true,
    terminal_colors = true,
    styles = {
      comments = "italic",
      keywords = "bold",
    },
    inverse = {
      visual = false,
    },
    hlgroups = {
      IndentBlanklineChar = { fg = '${comment}' },
      IndentBlanklineContextChar = { fg= '${pink}' },
      IndentBlanklineSpaceChar = { fg= '${comment}' },
      IndentBlanklineSpaceCharBlankLine = { fg= 'NONE' },
      DapBreakpointSign = { fg = '${red}' },
      DapBreakpointLine = { bg = '${diff.delete}' },
    }
  })

  nightfox.load()
end

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")


local indent_blankline
status, indent_blankline = pcall(require, "indent_blankline")
if not status then return end

indent_blankline.setup({
  show_end_of_line = true,
  space_char_blank_line = " ",
  show_current_context = true,
  show_current_context_start = true,
})

