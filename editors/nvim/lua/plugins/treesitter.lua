return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-refactor',
    'windwp/nvim-ts-autotag',
    'p00f/nvim-ts-rainbow',
    'David-Kunz/treesitter-unit',
    'JoosepAlviste/nvim-ts-context-commentstring',
  }
}
