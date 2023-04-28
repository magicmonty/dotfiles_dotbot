local map = vim.keymap.set
local remap = { remap = true }
local silent = { silent = true }

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', silent)

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move selected line with automatic indenting
map('v', 'J', ":m '>+1<CR>gv=gv", { remap = false, silent = true, desc = "Move selected line down" })
map('v', 'K', ":m '<-2<CR>gv=gv", { remap = false, silent = true, desc = "Move selected line up" })

map('n', '<C-S-Up>', ":move -2<CR>", { silent = true, desc = "Move current line up" })
map('n', '<C-S-Down>', ":move +<CR>", { silent = true, desc = "Move current line down" })

-- Insert mode
map('i', '<C-S-Up>', '<C-O><C-S-Up>', { silent = true, noremap = false })
map('i', '<C-S-Down>', '<C-O><C-S-Down>', { silent = true, noremap = false })

-- Join lines while keeping the cursor at the same position
map('n', 'J', "mzJ`z<Esc>", { desc = "Join line (keeps cursor)" })

-- Page Up/Down keeps the Cursor in the center
map('n', '<C-d>', '<C-d>zz', { desc = "Page down" })
map('n', '<C-u>', '<C-u>zz', { desc = "Page up" })

-- Make Alt+Up/Down work as PageUp and PageDown
map('n', '<M-Up>', '<C-u>zz', { desc = "Page up" })
map('i', '<M-Up>', '<C-u>zz', { desc = "Page up" })
map('v', '<M-Up>', '<C-u>zz', { desc = "Page up" })
map('n', '<M-Down>', '<C-d>zz', { desc = "Page down" })
map('i', '<M-Down>', '<C-d>zz', { desc = "Page down" })
map('v', '<M-Down>', '<C-d>zz', { desc = "Page down" })

-- remap common typo
map('n', 'q:', ':q', remap)

-- finding the next/previous search result keeps the cursor in the center
map('n', 'n', 'nzzzv', { desc = "Jump to next search result" })
map('n', 'N', 'Nzzzv', { desc = "Jump to previous search result" })
map('n', '*', '*zzzv', { desc = "Jump to next occurrence of word under cursor" })
map('n', '#', '#zzzv', { desc = "Jump to previous occurrence of word under cursor" })

-- Overload Control+L to clear the search highlight as it's redrawing the screen.
-- map('n', '<C-L>', ':nohlsearch<cr><C-L>', { remap = false, silent = true })
-- map('i', '<C-L>', '<Esc>:nohlsearch<cr><C-L>a', { remap = false, silent = true })
-- map('v', '<C-L>', '<Esc>:nohlsearch<cr><C-L>gv', { remap = false, silent = true })

-- Replace selected word without losing current paste buffer
map('x', '<leader>p', '"_dP', { desc = "Replace selection without losing paste buffer" })

map({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Yank into system clipboard" })
map('n', '<leader>Y', '"+Y', { desc = "Yank current line into system clipboard" })
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = "delete without putting deleted into paste buffer" })
map('n', '<leader>dd', '"_dd', { desc = "delete line without putting it into paste buffer" })

-- Disable ex mode (No one needs this)
map('n', 'Q', '<nop>')

-- Quicklist handling
map('n', '<leader>qn', '<cmd>cnext<CR>zz', { desc = "Go to next entry in quickfix list" })
map('n', '<leader>qp', '<cmd>cprev<CR>zz', { desc = "Go to previous entry in quickfix list" })
map('n', '<leader>qc', '<cmd>cclose<CR>', { desc = "close quickfix window" })

-- Locationlist handling
map('n', '<leader>ln', '<cmd>lnext<CR>zz', { desc = "Go to next entry in location list" })
map('n', '<leader>lp', '<cmd>lprev<CR>zz', { desc = "Go to previous entry in location list" })
map('n', '<leader>lc', '<cmd>lclose<CR>', { desc = "close location list window" })

-- map('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'replace word under cursor' })

-- Diagnostic keymaps
map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show current diagnostic in float" })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'open location list with diagnostics' })

-- Tab/Shift+Tab indent/unindent the highlighted block (and maintain the
-- highlight after changing the indentation). Works for both Visual and Select modes.
map('v', '<Tab>', '>gv')
map('v', '<S-Tab>', '<gv')

-- Toggle folding
map({ 'n', 'v' }, '<leader>mm', 'za', { desc = 'Toggle fold' })

-- <C-d> duplicates line or visual selection (cursor stays in position in normal and insert mode)
map('n', '<C-d>', 'mg""yyp`g:delm g<cr>', remap)
map('i', '<C-d>', '<C-O>mg<C-O>""yy<C-O>p<C-O>`g<C-O>:delm g<cr>', remap)
map('v', '<C-d>', '""y<up>""p', remap)

-- <C-S> saves the current file (if it's been changed).
map('', '<C-S>', ':update<CR>', silent)
map('v', '<C-S>', '<C-C>:update<CR>', silent)
map('i', '<C-S>', '<C-O>:update<CR>', silent)

-- split handling
map('n', 'sv', ':vsplit<cr><C-w>w', { silent = true, noremap = false })
map('n', 'ss', ':split<cr><C-w>w', { silent = true, noremap = false })
map('n', 'so', ':only<cr>', { silent = true, noremap = false })
map('n', 'sq', '<C-w>q')
map('n', 's<left>', '<C-w>h')
map('n', 'sh', '<C-w>h')
map('n', 's<right>', '<C-w>l')
map('n', 'sl', '<C-w>l')
map('n', 's<up>', '<C-w>k')
map('n', 'sk', '<C-w>k')
map('n', 's<down>', '<C-w>j')
map('n', 'sj', '<C-w>j')
map('n', '<C-w><C-left>', '5<C-w><')
map('n', '<C-w><C-right>', '5<C-w>>')
map('n', '<C-w><C-up>', '5<C-w>-')
map('n', '<C-w><C-down>', '5<C-w>+')


map('n', '<', ']')
map('x', '<', ']')
map('n', '>', ']')
map('x', '>', ']')

-- Increment and decrement with + and -
map('n', '+', '<C-a>')
map('n', '-', '<C-x>')

-- vim: ts=2 sts=2 sw=2 et
