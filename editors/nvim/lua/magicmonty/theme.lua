local icons = require('icons')

local M = {}

M.colorscheme = 'nightfox'

M.colors = require('nightfox.spec').load(M.colorscheme)

M.icons = icons

return M
