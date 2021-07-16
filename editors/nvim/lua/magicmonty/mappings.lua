local map = require("vim_ext").map
local silent = { silent = true }
local remap = { noremap = false }

-- Suppress literal <S-Insert> and paste instead
map('i', '<S-Insert>', '<C-r>+', silent)

-- Quickfix navigation
map('n', "<space>qn", ":cnext<cr>", silent)
map('n', "<space>qp", ":cprevious<cr>", silent)
map('n', "<space>qq", ":cquit<cr>", silent)

-- Backspace in Visual mode deletes selection.
map('v', '<BS>', 'd')

-- Tab/Shift+Tab indent/unindent the highlighted block (and maintain the
-- highlight after changing the indentation). Works for both Visual and Select modes.
map('v', '<Tab>', '>gv')
map('v', '<S-Tab>', '<gv')

-- Center the display line after searches. (This makes it *much* easier to see the matched line.)
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', '*', '*zz')
map('n', '#', '#zz')
map('n', 'g*', 'g*zz')
map('n', 'g#', 'g#zz')

-- Make Alt+Up/Down work as PageUp and PageDown
map('n', '<M-Up>', '<PageUp>')
map('i', '<M-Up>', '<PageUp>')
map('v', '<M-Up>', '<PageUp>')
map('n', '<M-Down>', '<PageDown>')
map('i', '<M-Down>', '<PageDown>')
map('v', '<M-Down>', '<PageDown>')

-- Overload Control+L to clear the search highlight as it's redrawing the screen.
map('n', '<C-L>', ':nohlsearch<cr><C-L>', silent)
map('i', '<C-L>', '<Esc>:nohlsearch<cr><C-L>a', silent)
map('v', '<C-L>', '<Esc>:nohlsearch<cr><C-L>gv', silent)

-- Buffer navigation with leader key
map('', '<leader>bn', ':bn<cr>', silent)
map('', '<leader>bp', ':bp<cr>', silent)

-- Remap common typo
map('', 'q:', ':q', remap)

-- Disable ex mode
map('', 'Q', '<Nop>', remap)

-- Toggle folding
map('n', '<leader>mm', 'za')
map('v', '<leader>mm', 'za')

-- exit insert mode quickly
map('i', 'jj', '<Esc>')
map('i', 'jk', '<Esc>')

-- <C-d> duplicates line or visual selection (cursor stays in position in normal and insert mode)
map('n', '<C-d>', 'mg""yyp`g:delm g<cr>', remap)
map('i', '<C-d>', '<C-O>mg<C-O>""yy<C-O>p<C-O>`g<C-O>:delm g<cr>', remap)
map('v', '<C-d>', '""y<up>""p', remap)

-- <C-S> saves the current file (if it's been changed).
map("", "<C-S>", ":update<CR>", silent)
map("v", "<C-S>", "<C-C>:update<CR>", silent)
map("i", "<C-S>", "<C-O>:update<CR>", silent)

-- AutoComplete with C-Space
map('i', '<C-space>', '<C-x><C-o>')

-- split handling
map('n', '<leader>v', ':vsplit<cr>', silent)
map('n', '<leader>s', ':split<cr>', silent)
map('n', '<leader>o', ':only<cr>', { silent = true, noremap = false })

-- Map Control+Up/Down to move lines and selections up and down.
-- Define maps for Normal and Visual modes, then re-use
-- them for Insert and Select.
-- Normal mode
map('n', '<C-S-Up>', ':move -2<cr>', silent)
map('n', '<C-S-Down>', ':move +<cr>', silent)

-- Visual mode (only; does not include Select mode)
map('x', '<C-S-Up>', ":move '<-2<CR>gv", silent)
map('x', '<C-S-Down>', ":move '>+<CR>gv", silent)

-- Insert mode
map('i', '<C-S-Up>', '<C-O><C-S-Up>', { silent = true, noremap = false })
map('i', '<C-S-Down>', '<C-O><C-S-Down>', { silent = true, noremap = false })

-- Select mode
map('s', '<C-S-Up>', '<C-G><C-Up><C-G>', { silent = true, noremap = false })
map('s', '<C-S-Down>', '<C-G><C-Down><C-G>', { silent = true, noremap = false })


