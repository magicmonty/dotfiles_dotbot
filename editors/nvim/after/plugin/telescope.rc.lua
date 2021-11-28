-- vim: foldlevel=99:
local status, telescope = pcall(require, 'telescope')
if not status then
  return
end

local map = require('vim_ext').map

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
    prompt_prefix = '❯ ',
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

if vim.g.plugs['telescope-file-browser.nvim'] then
  require('telescope').load_extension('file_browser')
end
if vim.g.plugs['telescope-zoxide'] then
  require('telescope').load_extension('zoxide')
end
if vim.g.plugs['telescope-dap.nvim'] then
  require('telescope').load_extension('dap')
end
if vim.g.plugs['telescope-project.nvim'] then
  require('telescope').load_extension('project')
end
if vim.g.plugs['nvim-neoclip.lua'] then
  telescope.load_extension('neoclip')
end

local opts = { silent = true, noremap = true }

-- Clipboard manager
map('n', '<leader>cc', ":lua require('telescope').extensions.neoclip.default()<cr>", opts)

-- Find projects
map('n', '<leader>fp', ":lua require('telescope').extensions.project.project({display_type = 'minimal'})<cr>", opts)

-- Find files in current project directory
map('n', '<leader>ff', ":lua require('magicmonty.telescope').project_files()<cr>", opts)
map('n', '<leader>fF', ":lua require('telescope.builtin').find_files()<cr>", opts)

-- Find text in current buffer
map('n', '<leader>fb', ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", opts)
-- Help
map('n', '<leader>fh', ":lua require('telescope.builtin').help_tags()<cr>", opts)
-- Browse notification history
map('n', '<leader>fn', ":lua require('telescope').extensions.notify.notify()<cr>", opts)
-- Browse keymaps
map('n', '<leader>fk', ":lua require('telescope.builtin').keymaps({results_title='Key Maps Results'})<cr>", opts)
-- Browse marks
map('n', '<leader>fm', ":lua require('telescope.builtin').marks({results_title='Marks Results'})<cr>", opts)
-- Find word under cursor
map('n', '<leader>fw', ":lua require('telescope.builtin').grep_string()<cr>", opts)
-- Find word under cursor (exact word, case sensitive)
map('n', '<leader>fW', ":lua require('telescope.builtin').grep_string({word_match='-w'})<cr>", opts)
-- Find buffer
map(
  'n',
  '<leader>bb',
  ":lua require('telescope.builtin').buffers({prompt_title = 'Find Buffer', results_title = 'Buffers', layout_strategy = 'vertical'})<cr>",
  opts
)
-- Live grep
map('n', '<leader>lg', ':Telescope live_grep<cr>', opts)
-- Find file in neovim config directory
map('n', '<leader>en', ":lua require('magicmonty.telescope').search_config()<cr>", opts)
-- Change to directory from zoxide db
map(
  'n',
  '<leader>cd',
  ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<cr>",
  opts
)

-- Wrap preview textt
vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
