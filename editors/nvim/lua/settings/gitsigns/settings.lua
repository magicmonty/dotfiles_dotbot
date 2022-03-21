require('gitsigns').setup({
  signcolumn = true,
  numhl = true,
  linehl = true,
  word_diff = false,

  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- navigation
    map('n', '<leader>gdn', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", { expr = true })
    map('n', '<leader>gdp', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", { expr = true })

    -- actions
    map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>')
    map({ 'n', 'v' }, '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>')
    map('n', '<leader>hb', '<cmd>Gitsigns blame_line<cr>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>')
    map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<cr>')
    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<cr>')
    map('n', '<leader>hU', '<cmd>Gitsigns reset_buffer_index<cr>')

    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
  end,
})
