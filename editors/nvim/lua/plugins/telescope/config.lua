local installed, telescope = pcall(require, 'telescope')
if not installed then return end

telescope.setup({
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

local function builtin()
  return require('telescope.builtin')
end

local function extensions()
  return require('telescope').extensions
end

-- Clipboard manager
map('n', '<leader>cc', extensions().neoclip.default, opts)

-- Change to directory from zoxide db
map('n', '<leader>cd', function()
  extensions().zoxide.list({ results_title = 'Z Directories', prompt_title = 'Z Prompt' })
end, opts)

-- Find projects
map('n', '<leader>fp', function()
  extensions().project.project({ display_type = 'minimal' })
end, opts)

-- Find files in current project directory
map('n', '<leader>ff', require('magicmonty.telescope').project_files, opts)
map('n', '<leader>fo', builtin().oldfiles, opts)
map('n', '<leader>fF', builtin().find_files, opts)

-- Find text in current buffer
map('n', '<leader>fb', builtin().current_buffer_fuzzy_find, opts)
-- Help
map('n', '<leader>fh', builtin().help_tags, opts)
-- Browse notification history
map('n', '<leader>fn', extensions().notify.notify, opts)
-- Browse keymaps
map('n', '<leader>fk', function()
  builtin().keymaps({ results_title = 'Key Maps Results' })
end, opts)
-- Browse marks
map('n', '<leader>fm', function()
  builtin().marks({ results_title = 'Marks Results' })
end, opts)
-- Find word under cursor
map('n', '<leader>fw', builtin().grep_string, opts)
-- Find word under cursor (exact word, case sensitive)
map('n', '<leader>fW', function()
  builtin().grep_string({ word_match = '-w' })
end, opts)
-- Find buffer
map('n', '<leader><Tab>', function()
  builtin().buffers({ prompt_title = 'Find Buffer', results_title = 'Buffers', layout_strategy = 'vertical' })
end, opts)
-- Live grep
map('n', '<leader>flg', builtin().live_grep, opts)
-- Find file in neovim config directory
map('n', '<leader>en', require('magicmonty.telescope').search_config, opts)
-- resume last Telescope session
map('n', ',,', builtin().resume, opts)


-- Wrap preview text
vim.api.nvim_create_autocmd('User TelescopePreviewerLoaded', { command = 'setlocal wrap' })
