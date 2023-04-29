-- Tree view
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return {
      desc = 'nvim-tree: ' .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  -- Default mappings.
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 'cd', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts('Open: Horizontal Split'))
end

return {
  'kyazdani42/nvim-tree.lua',
  dependencies = 'webdevicons',
  keys = {
    { '<leader>.', '<cmd>NvimTreeFindFileToggle<cr>', desc = 'NvimTree' },
  },
  config = function()
    local icons = require('magicmonty.theme').icons.diagnostics
    local tree_cb = require('nvim-tree.config').nvim_tree_callback

    require('nvim-tree').setup({
      on_attach = on_attach,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      update_cwd = false,
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      git = {
        ignore = true,
      },
      renderer = {
        highlight_opened_files = 'all',
        highlight_git = true,
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            default = '',
            symlink = '',
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '➜',
              untracked = '★',
              deleted = '',
              ignored = '◌',
            },
            folder = {
              arrow_open = '',
              arrow_closed = '',
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
              symlink_open = '',
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        icons = {
          hint = icons.Hint,
          info = icons.Information,
          warning = icons.Warning,
          error = icons.Error,
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = {
            exclude = {
              filetype = { 'packer', 'vim-plug', 'qf' },
            },
          },
        },
      },
    })
  end,
}
