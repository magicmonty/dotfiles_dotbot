local installed, cmp = pcall(require, 'cmp')
if not installed then return end

cmp.setup.buffer({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'treesitter' },
    { name = 'luasnip' },
    { name = 'path' },
  }
})
