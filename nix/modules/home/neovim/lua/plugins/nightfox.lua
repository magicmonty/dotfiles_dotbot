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
    require('magicmonty.theme').configure()

    vim.api.nvim_create_user_command(
      'ToggleDarkMode',
      function()
        local colorscheme = vim.g.colors_name == 'nightfox' and 'dayfox' or 'nightfox'
        vim.cmd('colorscheme ' .. colorscheme)
        require('lualine').setup({ options = { theme = colorscheme } })
      end,
      {}
    )
  end
}
