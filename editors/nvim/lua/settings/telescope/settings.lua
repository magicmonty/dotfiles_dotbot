-- vim: foldlevel=99:
require('telescope').setup({
  extensions = {
    project = {
      base_dirs = {
        { path = '~/src', max_depth = 2 },
      },
    },
  },
  defaults = {
    preview = {
      timeout = 500,
      msg_bg_fillchar = '',
    },
    prompt_prefix = '🔎 ',
    selection_caret = '❯ ',
    sorting_strategy = 'ascending',
    color_devicons = true,
    dynamic_preview_title = true,
    layout_config = {
      prompt_position = 'bottom',
      horizontal = {
        width_padding = 0.04,
        height_padding = 0.1,
        preview_width = 0.6,
      },
      vertical = {
        width_padding = 0.04,
        height_padding = 1,
        preview_height = 0.5,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--line-number',
      '--with-filename',
      '--column',
      '--smart-case',
      '--hidden',
      '--follow',
    },
    winblend = 10,
  },
})

vim.cmd([[
  packadd! nvim-dap
  packadd! nvim-dap-ui
  packadd! nvim-dap-virtual-text
  packadd! nvim-neoclip.lua
  packadd! telescope-dap.nvim
  packadd! telescope-file-browser.nvim
  packadd! telescope-fzf-native.nvim
  packadd! telescope-project.nvim
  packadd! telescope-zoxide
]])

local map = vim.keymap.set
local opts = { silent = true, noremap = true }

local function telescope()
  return require('telescope.builtin')
end
local function extensions()
  return require('telescope').extensions
end

-- Clipboard manager
map('n', '<leader>cc', function()
  extensions().neoclip.default()
end, opts)

-- Change to directory from zoxide db
map('n', '<leader>cd', function()
  extensions().zoxide.list({ results_title = 'Z Directories', prompt_title = 'Z Prompt' })
end, opts)

-- Find projects
map('n', '<leader>fp', function()
  extensions().project.project({ display_type = 'minimal' })
end, opts)

-- Find files in current project directory
map('n', '<leader>ff', function()
  require('magicmonty.telescope').project_files()
end, opts)
map('n', '<leader>fo', function()
  telescope().oldfiles()
end, opts)
map('n', '<leader>fF', function()
  telescope().find_files()
end, opts)

-- Find text in current buffer
map('n', '<leader>fb', function()
  telescope().current_buffer_fuzzy_find()
end, opts)
-- Help
map('n', '<leader>fh', function()
  telescope().help_tags()
end, opts)
-- Browse notification history
map('n', '<leader>fn', function()
  extensions().notify.notify()
end, opts)
-- Browse keymaps
map('n', '<leader>fk', function()
  telescope().keymaps({ results_title = 'Key Maps Results' })
end, opts)
-- Browse marks
map('n', '<leader>fm', function()
  telescope().marks({ results_title = 'Marks Results' })
end, opts)
-- Find word under cursor
map('n', '<leader>fw', function()
  telescope().grep_string()
end, opts)
-- Find word under cursor (exact word, case sensitive)
map('n', '<leader>fW', function()
  telescope().grep_string({ word_match = '-w' })
end, opts)
-- Find buffer
map('n', '<leader><Tab>', function()
  telescope().buffers({ prompt_title = 'Find Buffer', results_title = 'Buffers', layout_strategy = 'vertical' })
end, opts)
-- Live grep
map('n', '<leader>flg', function()
  telescope().live_grep()
end, opts)
-- Find file in neovim config directory
map('n', '<leader>en', function()
  require('magicmonty.telescope').search_config()
end, opts)

-- Wrap preview text
vim.api.nvim_create_autocmd('User TelescopePreviewerLoaded', { command = 'setlocal wrap' })
