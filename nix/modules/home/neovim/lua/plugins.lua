-- Plugins which don't need configuration
return {
  'nvim-lua/popup.nvim',

  'amadeus/vim-convert-color-to',

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-surround',

  -- SCSS syntax support
  'cakebaker/scss-syntax.vim',

  -- KDL support
  'imsnif/kdl.vim',

  -- Clojure / Overtone
  { 'guns/vim-clojure-static', ft = { 'clojure' } },
  { 'guns/vim-clojure-highlight', ft = { 'clojure' } },
  { 'tpope/vim-fireplace', ft = { 'clojure' } },
  { 'tpope/vim-classpath', ft = { 'clojure' } },
  { 'tpope/vim-sexp-mappings-for-regular-people', ft = { 'clojure' } },
  { 'guns/vim-sexp', ft = { 'clojure' } },
}
