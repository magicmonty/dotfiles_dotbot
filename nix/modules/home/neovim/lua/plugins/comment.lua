return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup({
      ---Add a space b/w comment and the line
      ---@type boolean
      padding = true,

      ---Whether the cursor should stay at its position
      ---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
      ---@type boolean
      sticky = false,

      ---Lines to be ignored while comment/uncomment.
      ---Could be a regex string or a function that returns a regex string.
      ---Example: Use '^$' to ignore empty lines
      ---@type string|fun():string
      ignore = nil,

      ---LHS of toggle mappings in NORMAL + VISUAL mode
      ---@type table
      toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
      },

      ---LHS of operator-pending mappings in NORMAL + VISUAL mode
      ---@type table
      opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
      },

      ---LHS of extra mappings
      ---@type table
      extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
      },

      ---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
      ---@type table
      mappings = {
        ---Operator-pending mapping
        ---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        ---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
        basic = true,
        ---Extra mapping
        ---Includes `gco`, `gcO`, `gcA`
        extra = true,
        ---Extended mapping
        ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
      },
    })

    local comment_ft = require('Comment.ft')
    comment_ft.set('lua', { '--%s', '--[[%s]]' })

    -- comment/uncomment line/block
    vim.keymap.set('n', '<leader>#', 'gcc', { remap = true })
    vim.keymap.set('v', '#', 'gb', { remap = true })
  end
}
