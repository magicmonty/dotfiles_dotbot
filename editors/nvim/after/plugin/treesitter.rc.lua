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
    highlight_current_scope = { enable = false }
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps =  {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      }
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer"
      }
    }
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
