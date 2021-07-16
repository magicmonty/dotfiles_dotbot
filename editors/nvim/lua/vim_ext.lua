-- vim: foldlevel=99:
local cmd = vim.cmd

local map = function(mode, leftHandSide, rightHandSide, opts)
  local options = { noremap = true }
  if opts then 
    options = vim.tbl_extend('force', options, opts) 
  end

  vim.api.nvim_set_keymap(mode, leftHandSide, rightHandSide, options)
end

local hi = function(group, opts)
	local c = "highlight " .. group
	
  for k, v in pairs(opts) do
		c = c .. " " .. k .. "=" .. v
	end

  cmd(c)
end

local init_autocmd = function(bufferOnly) 
  if bufferOnly then
    cmd 'autocmd! <buffer>'
  else
    cmd 'autocmd!'
  end
end

local au = function(autocmd) 
  cmd('autocmd ' .. table.concat(autocmd, ' '))
end

local augroup = function(name, autocmds, bufferOnly)
  cmd('augroup ' .. name)
  
  init_autocmd(bufferOnly)
  
  for _, autocmd in ipairs(autocmds) do
    au(autocmd)
  end
  
  cmd 'augroup END'
end

return {
  map = map,
  hi = hi,
  init_autocmd = init_autocmd,
  au = au,
  augroup = augroup
}
