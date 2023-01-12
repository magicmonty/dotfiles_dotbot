-- fast navigation
return {
  'ggandor/leap.nvim',
  config = function()
    vim.keymap.set({ 'n', 'x', 'o' }, 'ß', '<Plug>(leap-forward-to)')
  end
}
