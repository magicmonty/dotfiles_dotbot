local map = vim.keymap.set
local icons = require('magicmonty.theme').icons.diagnostics
local tree_cb = require('nvim-tree.config').nvim_tree_callback

vim.cmd([[
  let g:nvim_tree_git_hl = 1
  let g:nvim_tree_highlight_opened_files = 3
  let g:nvim_tree_icons = {
      \ 'default': '',
      \ 'symlink': '',
      \ 'git': {
      \   'unstaged': "✗",
      \   'staged': "✓",
      \   'unmerged': "",
      \   'renamed': "➜",
      \   'untracked': "★",
      \   'deleted': "",
      \   'ignored': "◌"
      \   },
      \ 'folder': {
      \   'arrow_open': "",
      \   'arrow_closed': "",
      \   'default': "",
      \   'open': "",
      \   'empty': "",
      \   'empty_open': "",
      \   'symlink': "",
      \   'symlink_open': "",
      \   }
      \ }
]])

map('n', '<leader>.', ':NvimTreeFindFileToggle<cr>', { noremap = true, silent = true })

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
    indent_markers = {
      enable = true
    }
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
