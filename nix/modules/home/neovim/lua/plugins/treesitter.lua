return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-refactor',
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'David-Kunz/treesitter-unit',
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
}
