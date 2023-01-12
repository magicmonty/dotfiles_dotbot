return {
  'L3MON4D3/LuaSnip',
  name = 'luasnip',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')

    local fn = vim.fn
    ls.config.set_config({
      -- Tells LuaSnip to remember to keep around the last used snippetNode
      -- You can jump back into it, even if you move outside of the selection
      history = true,

      -- Updates as you type on dynamic snippets
      updateevents = 'TextChanged,TextChangedI',

      enable_autosnippets = true,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { '<-', 'NonTest' } },
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

    local luasnip_snippets = vim.fn.stdpath('config') .. '/lua/magicmonty/snippets'
    require('luasnip.loaders.from_lua').load({ paths = luasnip_snippets })

    -- expand snippet or jump to next placeholder
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    -- jump backward
    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })

    -- select from choices
    vim.keymap.set({ 'i' }, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)

    vim.keymap.set('i', '<C-u>', require('luasnip.extras.select_choice'))
  end
}
