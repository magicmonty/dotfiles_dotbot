-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
return {
  'nvim-telescope/telescope-fzf-native.nvim',
  build = 'make',
  cond = vim.fn.executable 'make' == 1,
  dependencies = { 'telescope' }
}
