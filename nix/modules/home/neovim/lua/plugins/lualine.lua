-- Fancier statusline
return {
  'nvim-lualine/lualine.nvim',
  name = 'lualine',
  dependencies = {
    'nightfox'
  },
  config = function()
    local theme = require('magicmonty.theme')
    local icons = theme.icons
    local colors = theme.colors

    local function LspStatus()
      local status = ''
      if vim.lsp.buf_get_clients() then
        status = require('magicmonty.status').status()
      end

      return status
    end

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
      has_gitsigns_info = function()
        return vim.b.gitsigns_status_dict ~= nil
      end,
    }

    local config = {
      options = {
        icons_enabled = true,
        theme = vim.g.colors_name,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'NvimTree' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return icons.git.branch .. ' ' .. gitsigns.head
              end
            end,
            cond = conditions.has_gitsigns_info,
            separator = '',
          },
          {
            'diff',
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            symbols = {
              added = icons.git.added .. ' ',
              modified = icons.git.modified .. ' ',
              removed = icons.git.removed .. ' ',
            },
            diff_color = {
              added = { fg = colors.git.add },
              modified = { fg = colors.git.changed },
              removed = { fg = colors.git.removed },
            },
            cond = conditions.has_gitsigns_info,
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          {
            function()
              local total_lines = vim.fn.line('$')
              if total_lines > 1 then
                local current_line = vim.fn.line('.')
                local chars = {
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                }
                local line_ratio = current_line / total_lines
                local percentage = math.floor(line_ratio * 100)
                local index = math.ceil(line_ratio * #chars)
                return chars[index] .. ' ' .. string.format('%02d%%%%', percentage)
              end
              return ''
            end,
          },
        },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'fugitive' },
    }

    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left({ 'filename' })
    ins_right({
      'filetype',
      cond = conditions.buffer_not_empty,
      separator = '',
    })

    ins_right({ LspStatus, separator = '' })

    ins_right({
      function()
        local b = vim.api.nvim_get_current_buf()
        if next(vim.treesitter.highlighter.active[b]) then
          return ' '
        end
        return ''
      end,
      color = { fg = colors.palette.green.base },
    })

    ins_right({ 'encoding', cond = conditions.buffer_not_empty })

    require('lualine').setup(config)
  end
}
