-- Nice start page
return {
  'glepnir/dashboard-nvim',
  commit = 'e517188',
  config = function()
    local db = require('dashboard')
    local fn = vim.fn
    local plugin_count = fn.len(fn.globpath(fn.stdpath('data') .. '/lazy', '*', 0, 1))

    local empty_line = [[]]

    local header = {
      empty_line,
      empty_line,
      [[            .:-`                                                          ]],
      [[          `+oooo`                                                         ]],
      [[          +-  :o+                                                         ]],
      [[               /o-                                                        ]],
      [[               .oo`                                                       ]],
      [[               /oo:                dP                         oo          ]],
      [[              `oo+o`               88                                     ]],
      [[              :o:.o/      88d888b. 88d888b. .d8888b. 88d888b. dP .d8888b. ]],
      [[             `oo` /o.     88'  `88 88'  `88 88'  `88 88'  `88 88 88'  `   ]],
      [[             :o+  `oo` `  88.  .88 88    88 88.  .88 88    88 88 88.  ... ]],
      [[     -/++++:.oo-   :oo++  88Y888P' dP    dP `88888P' dP    dP dP `88888P' ]],
      [[    ++-..-:/ooo`    .-.   88                                              ]],
      [[ `--o+:------o+--`        dP                                              ]],
      [[    `/oo+///++`                                                           ]],
      [[       .-::-`                                                             ]],
      empty_line,
      empty_line,
    }

    db.custom_header = header
    db.custom_center = {
      {
        icon = ' ',
        desc = 'Find file                  ',
        shortcut = 'SPC f F',
        action = 'Telescope find_files',
      },
      {
        icon = ' ',
        desc = 'Find project file          ',
        shortcut = 'SPC f f',
        action = "lua require('magicmonty.telescope').project_files()",
      },
      {
        icon = ' ',
        desc = 'Find Project               ',
        shortcut = 'SPC f p',
        action = "lua require('telescope').extensions.project.project({ display_type = 'minimal' })",
      },
      {
        icon = ' ',
        desc = 'Recents                    ',
        shortcut = 'SPC f o',
        action = 'Telescope oldfiles',
      },
      {
        icon = ' ',
        desc = 'New File                   ',
        shortcut = 'SPC n f',
        action = 'DashboardNewFile',
      },
    }

    db.custom_footer = {
      ' ',
      ' NeoVim loaded ' .. plugin_count .. ' plugins ',
    }

    vim.keymap.set('n', '<leader>nf', '<cmd>DashboardNewFile<CR>')
  end
}
