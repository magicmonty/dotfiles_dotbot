local map = require('vim_ext').map
local icons = require('icons')
local tree_cb = require('nvim-tree.config').nvim_tree_callback

vim.cmd([[
  let g:nvim_tree_quit_on_open = 1 " 0 by default, closes the tree when you open a file
  let g:nvim_tree_indent_markers = 1
  let g:nvim_tree_git_hl = 1
  let g:nvim_tree_highlight_opened_files = 3
  let g:nvim_tree_window_picker_exclude = [ "filetype", [ "packer", "vim-plug", "qf" ] ]
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
  auto_close = true,
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
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.diagnostics.Hint,
      info = icons.diagnostics.Information,
      warning = icons.diagnostics.Warning,
      error = icons.diagnostics.Error,
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
})
