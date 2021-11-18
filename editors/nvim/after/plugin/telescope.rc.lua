-- vim: foldlevel=99:
local status, telescope = pcall(require, "telescope")
if (not status) then return end

local map=require("vim_ext").map
local actions = require("telescope.actions")

telescope.setup {
  extensions = {
    project = {
      base_dirs = {
        { path = "~/src", max_depth = 2 }
      }
    }
  },
  defaults = {
    preview = {
      timeout = 500,
    },
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    sorting_strategy = "ascending",
    color_devicons = true,
    dynamic_preview_title = true,
    layout_config = {
      prompt_position = "bottom",
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
      "rg",
      "--color=never",
      "--no-heading",
      "--line-number",
      "--with-filename",
      "--column",
      "--smart-case",
      "--hidden",
      "--follow"
    },
    winblend = 10,
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
      }
    }
  }
}

require("telescope").load_extension("ultisnips")
require("telescope").load_extension("zoxide")
require("telescope").load_extension("dap")
require("telescope").load_extension("project")

local opts = { silent = true, noremap = true }
map("n", "<leader>ff", ":lua require('magicmonty.telescope').project_files()<cr>", opts)
map("n", "<leader>fb", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", opts)
map("n", "<leader>fh", ":lua require('telescope.builtin').help_tags()<cr>", opts)
map("n", "<leader>fs", ":lua require('telescope').extensions.ultisnips.ultisnips()<cr>", opts)
map("n", "<leader>fn", ":lua require('telescope').extensions.notify.notify()<cr>", opts)
map("n", "<leader>fp", ":lua require('telescope').extensions.project.project({display_type = 'minimal'})<cr>", opts)
map("n", "<leader>bb", ":lua require('telescope.builtin').buffers()<cr>", opts)
map("n", "<leader>lg", ":Telescope live_grep<cr>", opts)
map("n", "<leader>en", ":lua require('magicmonty.telescope').search_config()<cr>", opts)
map("n", "<leader>cd", ":lua require'telescope'.extensions.zoxide.list{results_title='Z Directories', prompt_title='Z Prompt'}<cr>", opts)
map("n", "<leader>.",  ":lua require('telescope.builtin').file_browser()<cr>", opts)

