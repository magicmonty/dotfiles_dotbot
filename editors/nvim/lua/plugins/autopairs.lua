return {
  'windwp/nvim-autopairs',
  config = {
    disabled_filetype = { 'TelescopePrompt', 'dashboard' },
    check_ts = true,
    ts_config = {
      lua = { 'string' }, -- don't add auto pair on lua string nodes
    },
    enable_check_bracket_line = true,
    fast_wrap = {},
  }
}