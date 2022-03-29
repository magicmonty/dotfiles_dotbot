local M = {}

M.setup = function()
  local g = vim.g
  local fn = vim.fn

  local plugin_count = fn.len(fn.globpath(fn.stdpath('data') .. '/site/pack/packer/start', '*', 0, 1))

  g.dashboard_disable_statusline = 1
  g.dashboard_default_executive = 'telescope'
  g.dashboard_custom_header = {
    ' ',
    ' ',
    '           .:-`',
    '         `+oooo`',
    '         +-  :o+',
    '              /o-',
    '              .oo`',
    '              /oo:                dP                         oo',
    '             `oo+o`               88',
    '             :o:.o/      88d888b. 88d888b. .d8888b. 88d888b. dP .d8888b.',
    "            `oo` /o.     88'  `88 88'  `88 88'  `88 88'  `88 88 88'  `",
    '            :o+  `oo` `  88.  .88 88    88 88.  .88 88    88 88 88.  ...',
    "    -/++++:.oo-   :oo++  88Y888P' dP    dP `88888P' dP    dP dP `88888P'",
    '   ++-..-:/ooo`    .-.   88',
    '`--o+:------o+--`        dP',
    '   `/oo+///++`',
    '      .-::-`',
    ' ',
    ' ',
  }

  g.dashboard_custom_section = {
    a = { description = { '   Find File                 SPC f f' }, command = 'Telescope find_files' },
    b = { description = { '   Find Project              SPC f p' }, command = 'Telescope find_files' },
    c = { description = { '   Recents                   SPC f o' }, command = 'Telescope oldfiles' },
    d = { description = { '   New File                  SPC n f' }, command = 'DashboardNewFile' },
  }

  g.dashboard_custom_footer = {
    ' ',
    ' NeoVim loaded ' .. plugin_count .. ' plugins ',
  }

  vim.keymap.set('n', '<leader>nf', '<cmd>DashboardNewFile<CR>')
end

return M
