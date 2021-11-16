local fn = vim.fn

local au = require('vim_ext').au
local augroup = require('vim_ext').augroup
local use = fn['plug#']

local M = {}

function bootstrap()
  local data_dir = fn.stdpath('data')..'/site/autoload/plug.vim'
  if fn.empty(fn.glob(data_dir)) > 0 then
    vim.fn.execute('!curl -fLo '..data_dir..' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  end
end

M.init = function(init_plugins)
  bootstrap()

  -- Auto install when there are changes to plugins.lua
  augroup('plug_user_config', {
    -- au({ 'BufWritePost', 'plugins.lua', 'source <afile> | PlugClean | PlugInstall' })
    au({ 'BufWritePost', 'plugins.lua', 'source <afile>' })
  })

  local plugin_path = fn.stdpath('data')..'/plugged'
  vim.call('plug#begin', fn.glob(plugin_path))

  init_plugins(use)

  vim.call 'plug#end'

  -- Auto install and quit, if plugin path did not exist (bootstrapping)
  if fn.empty(fn.glob(plugin_path)) > 0 then
    vim.cmd [[ :PlugInstall! --sync ]]
    vim.cmd [[ :quitall ]]
  end
end

return M
