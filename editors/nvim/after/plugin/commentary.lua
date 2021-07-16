if not vim.g.loaded_commentary then return end

local map = require("vim_ext").map

-- comment/uncomment line/block
map('', '<leader>#', 'gcc', {noremap = false})
