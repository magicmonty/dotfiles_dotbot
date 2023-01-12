-- Tree view
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
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      open_on_setup = false,
      update_cwd = true,
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
      view = {
        mappings = {
          list = {
            { key = 'cd', cb = tree_cb('cd') },
            { key = { '<C-s>', '<C-x>', '<C-h>' }, cb = tree_cb('split') },
          },
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

  end
}
