local status, _ = pcall(require, "luasnip")
if not status then return end

local fn = vim.fn

local data_path = fn.stdpath('data')
local plugin_path = data_path .. '/plugged'
local my_snippets = fn.glob(data_path .. '/snippets')
local friendly_snippets = fn.glob(plugin_path..'/friendly-snippets')

local paths = {}
if fn.empty(my_snippets) == 0 then
  table.insert(paths, my_snippets)
end
if fn.empty(friendly_snippets) == 0 then
  table.insert(paths, friendly_snippets)
end

require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })
