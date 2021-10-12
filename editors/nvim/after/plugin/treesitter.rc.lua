-- vim: foldlevel=99:
local status, treesitterConfigs = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

treesitterConfigs.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true }
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000
  },
  ensure_installed = {
    "toml",
    "yaml",
    "json",
    "html",
    "scss",
    "c_sharp",
    "dockerfile",
    "javascript",
    "typescript",
    "clojure",
    "lua",
    "regex",
    "ruby"
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
