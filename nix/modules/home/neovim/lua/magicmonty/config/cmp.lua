local M = {}

local cmp_mappings = function()
  local installed, cmp = pcall(require, 'cmp')
  if not installed then return {} end

  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  return {
      -- Select next/prev item with C-n and C-p
      ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      -- Scroll docs
      ['<C-d>'] = cmp.mapping.scroll_docs( -4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- close completion
      ['<C-e>'] = cmp.mapping.close(),
      -- Confirm completion with C-a
      ['<C-a>'] = cmp.mapping(
          cmp.mapping.confirm({
              select = true,
              behavior = cmp.ConfirmBehavior.Replace
          }),
          { 'i', 'c' }
      ),
      -- Start completion with C-Space
      ['<C-Space>'] = cmp.mapping.complete(),
      -- disable confirm completion with Enter
      ['<CR>'] = cmp.config.disable,
      -- disable tab completion
      ['<Tab>'] = cmp.config.disable,
      ['<S-Tab>'] = cmp.config.disable,
  }
end

M.get_sorting = function()
  local compare = require("cmp").config.compare

  return {
      comparators = {
          compare.offset,
          compare.exact,
          compare.score,
          compare.order,

          -- copied from cmp-under, but I don't think I need the plugin for this.
          -- I might add some more of my own.
          -- sorts items starting with underlines better
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find('^_+')
            local _, entry2_under = entry2.completion_item.label:find('^_+')
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          compare.kind,
          compare.sort_text,
          compare.length,
      },
  }
end

M.get_options = function()
  local installed, cmp = pcall(require, 'cmp')
  if not installed then return {} end

  local autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', autopairs.on_confirm_done({ map_char = { tex = '' } }))

  return {
      mapping = cmp_mappings(),
      documentation = {
          border = 'rounded'
      },
      sorting = M.get_sorting(),
      formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end

            return require('lspkind').cmp_format({
                    with_text = true,
                    menu = {
                        nvim_lsp = 'ﲳ',
                        nvim_lsp_document_symbol = 'ﲳ',
                        nvim_lua = '',
                        treesitter = '',
                        path = 'ﱮ',
                        buffer = '﬘',
                        luasnip = '',
                        orgmode = '',
                        sonicpi = '',
                        emmet_vim = 'e'
                    },
                })(entry, vim_item)
          end
      },
      sources = {
          { name = 'path' },
          { name = 'sonicpi' },
          { name = 'neorg' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_document_symbol' },
          { name = 'treesitter' },
          { name = 'luasnip' },
          { name = 'emmet_vim' },
      }
  }
end


return M
