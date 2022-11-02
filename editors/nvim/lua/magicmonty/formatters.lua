local M = {}

local f = require('vim_ext')

M.stylua = function()
  if f.file_exists('.stylua.toml') then
    return {
      exe = 'stylua',
      args = {
        '--config-path .stylua.toml',
        '-',
      },
      stdin = true,
    }
  else
    return {
      exe = 'stylua',
      args = {
        '-',
      },
      stdin = true,
    }
  end
end

M.prettier = function()
  return {
    exe = 'prettier',
    args = {
      '--stdin-filepath',
      vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
      '--single-quote',
    },
    stdin = true,
  }
end

return M
