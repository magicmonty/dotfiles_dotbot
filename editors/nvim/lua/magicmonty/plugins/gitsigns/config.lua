local installed, gitsigns = pcall(require, 'gitsigns')
if not installed then return end

local icons = require('magicmonty.icons')

gitsigns.setup {
  signcolumn = true,
  numhl = true,
  linehl = false,
  word_diff = false,

  on_attach = function(_)
    local map = vim.keymap.set
    --
    -- navigation
    map('n', '<leader>gdn', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", { expr = true })
    map('n', '<leader>gdp', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", { expr = true })

    -- actions
    map({ 'n', 'v' }, '<leader>hs', function() vim.cmd.Gitsigns('stage_hunk') end)
    map({ 'n', 'v' }, '<leader>hu', function() vim.cmd.Gitsigns('undo_stage_hunk') end)
    map('n', '<leader>hb', function() vim.cmd.Gitsigns('blame_line') end)
    map('n', '<leader>hp', function() vim.cmd.Gitsigns('preview_hunk') end)
    map('n', '<leader>hr', function() vim.cmd.Gitsigns('reset_hunk') end)
    map('n', '<leader>hR', function() vim.cmd.Gitsigns('reset_buffer') end)
    map('n', '<leader>hS', function() vim.cmd.Gitsigns('stage_buffer') end)
    map('n', '<leader>hU', function() vim.cmd.Gitsigns('reset_buffer_index') end)

    map({ 'o', 'x' }, 'ih', '<cmd><C-U>Gitsigns select_hunk<cr>')
  end,

  signs = {
    add = { text = icons.git.added },
    change = { text = icons.git.modified },
    delete = { text = icons.git.removed },
    topdelete = { text = '‾' },
    changedelete = { text = icons.git.modified },
  },
}

-- vim: ts=2 sts=2 sw=2 et
