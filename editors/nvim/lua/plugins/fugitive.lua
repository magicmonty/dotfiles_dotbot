return {
  'tpope/vim-fugitive',
  config = function()
    -- Fugitive bindings
    vim.keymap.set('n', '<leader>gs', '<cmd>Git<cr>', { remap = false, silent = true, desc = "Git status" })
  end
}
