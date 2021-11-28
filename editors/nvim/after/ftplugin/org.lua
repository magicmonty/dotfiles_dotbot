local status, cmp = pcall(require, 'cmp')
if not status then
  return
end

cmp.setup.buffer({
  sources = {
    { name = 'orgmode' },
    { name = 'treesitter' },
    { name = 'luasnip' },
    { name = 'path' },
  },
})

local hasbullets, bullets = pcall(require, 'org-bullets')
if hasbullets then
  bullets.setup({
    symbols = {
      '◉',
      '○',
      '●',
      '◆',
      '◇',
      '✸',
      '✿',
      '✱',
      '✳',
      '✲',
      '✱',
      '✷',
      '✶',
      '✹',
      '✺',
      '✻',
      '✼',
      '✽',
      '✾',
      '✿',
      '❀',
      '❁',
    },
  })
end

vim.api.nvim_set_keymap('n', '<leader>cc', '<Plug>SnipRun', {})
vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>SnipRunOperator', {})
vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', {})
