-- Add indentation guides even on blank lines
return {
  'lukas-reineke/indent-blankline.nvim',
  config = {
    char = '┊',
    show_trailing_blankline_indent = false,
    filetype_exclude = { 'dashboard' }
  }
}
