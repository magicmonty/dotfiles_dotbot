local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local options = {
  dev = {
    path = '~/src/plugins',
    patterns = { 'sonicpi' }
  },
  ui = {
    border = "rounded"
  },
  change_detections = {
    notify = false,
  }
}

require('lazy').setup('plugins', options)
