local status, _ = pcall(require, "luasnip")
if not status then return end

local fn = vim.fn
require("luasnip.loaders.from_vscode").lazy_load()

local data_path = fn.stdpath('data')
local plugin_path = data_path .. '/plugged'
local paths = {}

local my_snippets = fn.glob(data_path .. '/snippets')
if vim.fn.empty(my_snippets) == 0 then
  table.insert(paths, my_snippets)
end

local friendly_snippets = fn.glob(plugin_path..'/friendly-snippets')
if vim.fn.empty(friendly_snippets) == 0 then
  table.insert(paths, friendly_snippets)
end

if vim.fn.empty(paths) == 0 then
  require("luasnip.loaders.from_vscode").lazy_load(paths)
end
