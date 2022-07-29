local rest = require('rest-nvim')
local mappings = require('magicmonty.mappings')

mappings.register({
  r = { rest.run, 'Run request' },
  R = { '<Plug>RestNvimPreview', 'Run request preview' },
}, { prefix = '<leader>', buffer = 0, mode = 'n', noremap = true, silent = true })

mappings.register({
  ['<C-j>'] = { require('magicmonty.jwt').decode, "JWT" }
}, { buffer = 0, mode = 'v', noremap = true, silent = true })
