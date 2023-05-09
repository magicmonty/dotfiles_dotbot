-- Add indentation guides even on blank lines
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
      show_current_context = false,
      filetype_exclude = {
        'dashboard',
        'help',
        'alpha',
        'neo-tree',
        'NvimTree',
        'Trouble',
        'lazy',
        'mason',
        'null-ls-info',
      },
    },
  },
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      symbol = '┊',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'help', 'alpha', 'dashboard', 'neo-tree', 'NvimTree', 'Trouble', 'lazy', 'mason', 'null-ls-info' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require('mini.indentscope').setup(opts)
    end,
  },
}
