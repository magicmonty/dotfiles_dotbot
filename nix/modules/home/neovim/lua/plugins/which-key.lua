return {
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    local wk = require('which-key')
    wk.setup({})

    wk.register({
      b = { name = 'Buffer', },
      c = { name = 'Code', },
      d = { name = 'Diagnostics', },
      g = { name = 'Git', },
      l = { name = 'location list' },
      q = { name = 'quickfix list' },
      r = { name = 'refactor' },
      s = { name = 'Search' },
      t = { name = 'Terminal' },
      T = { name = 'Tab' },
    }, { prefix = '<leader>' })
    wk.register({
      gt = { name = 'Todo Comments' }
    })
  end
}
