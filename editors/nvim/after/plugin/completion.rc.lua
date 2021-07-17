local status, compe = pcall(require, "compe")
if not status then return end

local map = require("vim_ext").map

vim.o.completeopt = "menuone,noinsert"

compe.setup({
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    ultisnips = true,
  }
})

-- Tab support for navigating the completion list
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match('%s') ~= nil
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    return t "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.shift_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    return t "<C-R>=UltiSnips#JumpBackwards()<CR>"
  else
    return t "<S-Tab>"
  end
end

local expr = { expr = true }
vim.cmd'let g:lexima_no_default_rules = v:true'
vim.cmd'call lexima#set_default_rules()'

map('i', '<c-space>', 'compe#complete()', expr)
map('i', '<cr>', 'compe#confirm(lexima#expand("<LT>CR>", "i"))', expr)
map('i', '<c-e>', 'compe#close("<C-e>")', expr)

map("i", "<Tab>", "v:lua.tab_complete()", expr)
map("s", "<Tab>", "v:lua.tab_complete()", expr)
map("i", "<S-Tab>", "v:lua.shift_tab_complete()", expr)
map("s", "<S-Tab>", "v:lua.shift_tab_complete()", expr)

-- vim: foldlevel=99:
