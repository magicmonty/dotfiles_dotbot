return {
  'nvim-tree/nvim-web-devicons',
  name = 'webdevicons',
  opts = {
    -- your personnal icons can go here (to override)
    -- DevIcon will be appended to `name`
    override = {
      zsh = { icon = '', color = '#428850', name = 'Zsh' },
      lua = { icon = '', color = '#4E99DF', name = 'Lua' },
      md = { icon = '', color = '#6BD02B', name = 'md' },
      MD = { icon = '', color = '#6BD02B', name = 'MD' },
      ['.gitignore'] = { icon = '', color = '#F14E32', name = 'GitIgnore' },
    },
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
  },
}
