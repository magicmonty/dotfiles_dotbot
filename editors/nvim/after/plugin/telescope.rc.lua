-- vim: foldlevel=99:
local status, telescope = pcall(require, "telescope")
if (not status) then return end

local map=require("vim_ext").map
local actions = require("telescope.actions")

telescope.setup { 
  defaults = {
    prompt_prefix = "$ ",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top"
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

local opts = { silent = true, noremap = true }
map("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<cr>", opts)
map("n", "<leader>fb", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", opts)
map("n", "<leader>fh", ":lua require('telescope.builtin').help_tags()<cr>", opts)
map("n", "<leader>fs", ":lua require('telescope').extensions.ultisnips.ultisnips()<cr>", opts)
map("n", "<leader>bb", ":lua require('telescope.builtin').buffers()<cr>", opts)
map("n", "<leader>lg", ":Telescope live_grep<cr>", opts)
map("n", "<leader>en", ":lua require('magicmonty.telescope').search_config()<cr>", opts)

