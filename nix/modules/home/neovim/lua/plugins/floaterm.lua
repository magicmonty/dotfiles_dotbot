return {
  'voldikss/vim-floaterm',
  config = function()
    local map = vim.keymap.set

    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_title = 0
    vim.g.floaterm_position = 'center'
    vim.g.floaterm_autoclose = 1

    map('n', '<leader>tt', ':FloatermToggle<cr>', { silent = true, noremap = true })
    map('n', '<leader>tv', ':FloatermNew --wintype=vsplit --width=0.5<cr>', { silent = true, noremap = true })
    map('n', '<leader>th', ':FloatermNew --wintype=split --height=0.5<cr>', { silent = true, noremap = true })
    map('n', '<leader>tq', ':FloatermKill<cr>', { silent = true, noremap = true })
    map('n', '<C-y>', ':FloatermToggle<cr>', { silent = true, noremap = true })
    map('n', '<C-Y>', ':FloatermToggle<cr>', { silent = true, noremap = true })
    map('i', '<C-y>', '<Esc>:FloatermToggle<cr>', { silent = true, noremap = true })
    map('t', '<C-y>', '<C-\\><C-n>:FloatermToggle<cr>', { silent = true, noremap = true })
    map('t', '<C-q>', '<C-\\><C-n>:FloatermKill<cr>', { silent = true, noremap = true })

    -- Generic terminal maps
    map('t', '<C-w>h', '<C-\\><C-n><C-w>h')
    map('t', '<C-w><Left>', '<C-\\><C-n><C-w>h')
    map('t', '<C-w>l', '<C-\\><C-n><C-w>l')
    map('t', '<C-w><Right>', '<C-\\><C-n><C-w>l')
    map('t', '<C-w>j', '<C-\\><C-n><C-w>j')
    map('t', '<C-w><Down>', '<C-\\><C-n><C-w>j')
    map('t', '<C-w>k', '<C-\\><C-n><C-w>k')
    map('t', '<C-w><Up>', '<C-\\><C-n><C-w>k')

    -- Remap <C-\><C-n> to <Esc> in terminal mode
    local floatermGroup = Augroup('FloaTerm', { clear = true })

    Autocmd('TermOpen', {
      pattern = '*',
      command = 'tnoremap <Esc> <C-\\><C-n>',
      group = floatermGroup 
    })

    Autocmd('BufEnter', {
      pattern = '*',
      command = "if &buftype == 'terminal' | :startinsert | endif",
      group = floatermGroup
    })
  end
}
