local ls = require('luasnip')
local s = ls.s
local i = ls.i

local fmt = require('luasnip.extras.fmt').fmta

local snippets = {
  s(
    { trig = 'snip', dscr = "Code for adding a LuaSnip snippet" },
    fmt(
      [[
        s(
          { trig = '<>',  dscr = '<>' },
          {
            <>
          }
        )
      ]],
      { i(1), i(2), i(0) }
    )
  )
}

return snippets
