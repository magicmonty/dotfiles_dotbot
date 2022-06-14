local rest = require('rest-nvim')
local wk = require('which-key')
wk.register({
  r = { rest.run, 'Run request' },
  R = { '<Plug>RestNvimPreview', 'Run request preview' },
}, { prefix = '<leader>', buffer = 0, mode = 'n', noremap = true, silent = true })
