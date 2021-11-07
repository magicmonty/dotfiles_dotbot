local status, notify = pcall(require, "notify")
if not status then return end

notify.setup {
  background_colour = require("nightfox.colors").init().bg
}

vim.notify = notify

