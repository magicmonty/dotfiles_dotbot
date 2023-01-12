-- Theme
return {
  'EdenEast/nightfox.nvim',
  name = 'nightfox',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all other plugins
  dependencies = {
    'webdevicons'
  },
  config = function()
    require('magicmonty.theme').setup()
  end
}
