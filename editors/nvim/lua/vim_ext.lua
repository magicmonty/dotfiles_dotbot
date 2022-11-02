-- vim: foldlevel=99:
local cmd = vim.cmd

local M = {}

M.map = function(mode, leftHandSide, rightHandSide, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  vim.api.nvim_set_keymap(mode, leftHandSide, rightHandSide, options)
end

M.hi = function(group, opts)
  local c = 'highlight ' .. group

  for k, v in pairs(opts) do
    c = c .. ' ' .. k .. '=' .. v
  end

  cmd(c)
end

M.init_autocmd = function(bufferOnly)
  if bufferOnly then
    cmd('autocmd! <buffer>')
  else
    cmd('autocmd!')
  end
end

M.au = function(autocmd)
  cmd('autocmd ' .. table.concat(autocmd, ' '))
end

M.augroup = function(name, autocmds, bufferOnly)
  cmd('augroup ' .. name)

  M.init_autocmd(bufferOnly)

  for _, autocmd in ipairs(autocmds) do
    M.au(autocmd)
  end

  cmd('augroup END')
end

M.file_exists = function(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return M
