return {
  'NTBBloodbath/color-converter.nvim',
  config = function()
    vim.keymap.set('n', '<leader>cc', '<Plug>ColorConvertCylcle')
  end,
}
