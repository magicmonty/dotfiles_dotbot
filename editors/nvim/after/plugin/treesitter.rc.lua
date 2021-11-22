local status, treesitterConfigs = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org'
}

treesitterConfigs.setup {
  highlight = {
    enable = true,
    disable = { "latex" },
    additional_vim_regex_highlighting = true
  },
  indent = {
    enable = false,
    disable = { "yaml" },
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
  context_commentstring = {
    enable = true,
    config = {
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = ""
    }
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
    "ruby",
    "org"
  },
}


vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 5

-- vim: foldlevel=99
