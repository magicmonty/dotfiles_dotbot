local fn = vim.fn
local ls = require('luasnip')
local types = require('luasnip.util.types')

ls.config.set_config({
  -- Tells LuaSnip to remember to keep around the last used snippetNode
  -- You can jump back into it, even if you move outside of the selection
  history = true,

  -- Updates as you type on dynamic snippets
  updateevents = 'TextChanged,TextChangedI',

  enable_auto_snippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '<-', 'Error' } },
      },
    },
  },
})

local data_path = fn.stdpath('data')
local plugin_path = data_path .. '/plugged'
local my_snippets = fn.glob(data_path .. '/snippets')
local friendly_snippets = fn.glob(plugin_path .. '/friendly-snippets')

local paths = {}
if fn.empty(my_snippets) == 0 then
  table.insert(paths, my_snippets)
end
if fn.empty(friendly_snippets) == 0 then
  table.insert(paths, friendly_snippets)
end

require('luasnip.loaders.from_vscode').lazy_load({ paths = paths })
