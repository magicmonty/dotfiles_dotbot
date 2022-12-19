-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`

local installed, indent_blankline = pcall(require, 'indent_blankline')
if not installed then return end

indent_blankline.setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- vim: ts=2 sts=2 sw=2 et
