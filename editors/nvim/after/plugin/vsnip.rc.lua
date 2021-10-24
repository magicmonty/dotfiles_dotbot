if not vim.g.loaded_vsnip then return end
vim.g.vsnip_snippet_dirs = ({
  vim.fn.expand("~/.config/nvim-data/snippets")
})

-- Jump forward or backward
vim.api.nvim_set_keymap('i', '<Tab>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'", { expr = true })

-- Select or cut text to use as $TM_SELECTED_TEXT in the next snippet
vim.api.nvim_set_keymap('n', 's', '<Plug>(vsnip-select-text)', {})
vim.api.nvim_set_keymap('x', 's', '<Plug>(vsnip-select-text)', {})
vim.api.nvim_set_keymap('n', 'S', '<Plug>(vsnip-cut-text)', {})
vim.api.nvim_set_keymap('x', 'S', '<Plug>(vsnip-cut-text)', {})

