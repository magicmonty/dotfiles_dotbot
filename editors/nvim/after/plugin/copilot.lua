local map = require("vim_ext").map
vim.g.copilot_no_tab_map = true

-- Remap Copilot-Accept from <Tab> to <C-j>
map('i', '<C-j>', 'copilot#Accept()', {silent = true, nowait = true, expr = true, script = true})


