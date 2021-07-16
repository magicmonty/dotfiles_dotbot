-- vim: foldlevel=99:
local vim_ext = require("vim_ext")
local hi = vim_ext.hi
local augroup = vim_ext.augroup
local opt = vim.opt

--
-- Highlights
-- ----------
opt.cursorline = true

-- Set cursor line color on visual mode
hi("Visual", {cterm = "NONE", ctermbg = "236", ctermfg = "NONE", guibg = "Grey40" })
hi("LineNr", {cterm = "NONE", ctermfg = "240", guifg = "2b506e", guibg = "#000000" })

-- Highlight column 120
opt.colorcolumn = "120"
hi("ColorColumn", { ctermbg = "10" })

-- Hide cursorline on inactive windows
augroup("BgHighlight", {
  { "WinEnter", "*", "set cursorline" },
  { "WinLeave", "*", "set nocursorline" }
})

