local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername

local M = {}

local opts = {
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = false,
    disable = { 'yaml' },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
  matchup = { enable = true },
  rainbow = {
    disable = { 'html' },
    enable = true,
    extended_mode = true, -- don't highlight non parentheses delimiters
    max_file_lines = 5000,
  },
  autotag = { enable = true },
  autopairs = { enable = true },
  context_commentstring = {
    enable = true,
    config = {
      typescript = '// %s',
      css = '/* %s */',
      scss = '/* %s */',
      html = '<!-- %s -->',
      vue = '<!-- %s -->',
      json = '',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
  },
  ensure_installed = {
    'bash',
    'c_sharp',
    'comment',
    'css',
    'dockerfile',
    'go',
    'html',
    'http',
    'javascript',
    'json',
    'json5',
    'jsonc',
    'latex',
    'lua',
    'ninja',
    'org',
    'php',
    'phpdoc',
    'python',
    'regex',
    'ruby',
    'scss',
    'supercollider',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml',
  },
  sync_install = false,
}

M.setup = function()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then
    return
  end

  local status, treesitter = pcall(require, 'nvim-treesitter.configs')
  if not status then
    return
  end

  treesitter.setup(opts)

  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.opt.foldlevel = 99
  vim.opt.fillchars = 'fold:-'
  vim.wo.foldmethod = 'expr'
  vim.o.foldtext =
  [['--- ' . substitute(getline(v:foldstart),'\\t',repeat(' ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines) ']]
end

return M

-- vim: foldlevel=99
