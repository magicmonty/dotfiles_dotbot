local map = require("vim_ext").map

if not vim.g.loaded_completion then return end

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Use <Tab> and <S-Tab> to navigate through popup menu
map("i", "<Tab>", "pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"", { noremap = true, expr = true })
map("i", "<S-Tab>", "pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"", { noremap = true, expr = true })

vim.g.completion_confirm_key = ""
map("i", "<cr>", "pumvisible() ? complete_info()[\"selected\"] != \"-1\" ? \"\\<Plug>(completion_confirm_completion)\" : \"\\<c-e>\\<CR>\" : \"\\<CR>\"", { expr = true })
