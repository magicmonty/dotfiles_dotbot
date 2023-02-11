-- Add indentation guides even on blank lines
return {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
        char = '┊',
        show_trailing_blankline_indent = false,
        filetype_exclude = { 'dashboard' }
    }
}
