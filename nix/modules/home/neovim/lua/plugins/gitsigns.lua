return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    local icons = require('magicmonty.icons')

    gitsigns.setup({
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,

      on_attach = function(_)
        local map = vim.keymap.set
        --
        -- navigation
        map(
          'n',
          '<leader>gn',
          "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'",
          { remap = false, expr = true, desc = 'Next hunk' }
        )
        map(
          'n',
          '<leader>gp',
          "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'",
          { remap = false, expr = true, desc = 'Previous hunk' }
        )

        -- actions
        map('n', '<leader>gb', function()
          vim.cmd.Gitsigns('blame_line')
        end, { remap = false, desc = 'blame line' })

        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>', { desc = 'inner hunk' })
      end,

      signs = {
        add = { text = '| ' },
        change = { text = '| ' },
        delete = { text = icons.git.removed },
        topdelete = { text = '‾' },
        changedelete = { text = '| ' },
        untracked = { text = '| ' },
      },
    })
  end,
}
