local ls = require('luasnip')
local s = ls.s
local f = ls.function_node

local date = function() return { os.date('%d.%m.%Y') } end

local snippets = {
  s(
    {
      trig = "dateDMY",
      name = "Date",
      dscr = "Date in form of DD.MM.YYYY"
    },
    { f(date, {}) })
}

return snippets
