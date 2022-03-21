local nightfox = require('nightfox.pallet.nightfox')
local icons = require('icons')

local M = {}

M.colors = {
  spec = nightfox.generate_spec(nightfox.pallet),
  pallet = nightfox.pallet,
}

M.icons = icons

return M
