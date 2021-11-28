require('magicmonty.settings')
require('magicmonty.highlighting')
require('magicmonty.filetype_settings')
require('magicmonty.plugins')
require('magicmonty.mappings')
require('magicmonty.theme')

function DN(value)
  require('notify')(vim.inspect(value))
end
