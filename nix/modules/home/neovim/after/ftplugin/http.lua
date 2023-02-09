local installed, rest = pcall(require, 'rest-nvim')
if not installed then return end

vim.keymap.set('n', '<leader>r', rest.run, { buffer = 0, noremap = true, desc = '[R]un request' })
vim.keymap.set('n', '<leader>R', vim.cmd.RestNvimPreview,
  { buffer = 0, silent = true, noremap = true, desc = '[R]un request preview' })
vim.keymap.set('v', '<C-j>', require('magicmonty.jwt').decode,
  { buffer = 0, silent = true, noremap = true, desc = 'Decode selected [J]WT token' })
