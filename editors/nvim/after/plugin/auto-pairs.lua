local status, auto_pairs = pcall(require, "nvim-autopairs")
if not status then return end

auto_pairs.setup {
  disabled_filetype = { "TelescopePrompt" },
  check_ts = true,
  ts_config = {
    lua = { 'string' }, -- don't add auto pair on lua string nodes
  },
  enable_check_bracket_line = true,
  fast_wrap = {}
}

