local M = {}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
local opts = {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'bibtex',
    'c_sharp',
    'comment',
    'css',
    'dockerfile',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'html',
    'http',
    'javascript',
    'json',
    'json5',
    'jsonc',
    'latex',
    'lua',
    'markdown',
    'markdown_inline',
    'regex',
    'ruby',
    'scss',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'yaml'
  },
  auto_install = true,
  sync_install = false,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false
  },
  indent = {
    enable = true,
    diable = { 'yaml' }
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
  matchup = { enable = true },
  rainbow = {
    enable = true,
    disable = { 'html' },
    extended_mode = true, -- don't highlight non parentheses delimiters
    max_file_lines = 3000,
  },
  autotag = { enable = true },
  autopairs = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      typescript = '// %s',
      css = '/* %s */',
      scss = '/* %s */',
      html = '<!-- %s -->',
      vue = '<!-- %s -->',
      sonicpi = { __default = '# %s', __multiline = '=begin %s =end' },
      ruby = { __default = '# %s', __multiline = '=begin %s =end' },
      json = '',
    }
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

local has_plugin, context_comment_string = pcall(require, 'ts_context_commentstring.internal')
if has_plugin then
  context_comment_string.update_commentstring({
    key = '__multiline'
  })
end

M.configure = function()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then return end

  local installed, treesitter = pcall(require, "nvim-treesitter.configs")
  if not installed then return end


  treesitter.setup(opts)

  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.opt.foldlevel = 99
  vim.opt.fillchars = 'fold:-'
  vim.wo.foldmethod = 'expr'
  vim.o.foldtext =
  [['--- ' . substitute(getline(v:foldstart),'\\t',repeat(' ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines) ']]

  local comment_installed, comment = pcall(require, 'Comment')
  if comment_installed then
    comment.setup {
      -- integration with treesitter context comment string
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  end
end

return M
