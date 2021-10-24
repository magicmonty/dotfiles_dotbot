local status, cmp = pcall(require, "cmp")
if not status then return end

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },

  experimental = {
    native_menu = false,
    ghost_text = true
  },

  mapping = {
    -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
          press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          press("<Esc>:call UltiSnips#JumpForwards()<CR>")
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          press("<Tab>")
        else
          fallback()
        end
      end,
      { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(
      function(fallback)
        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
          press("<Esc>:call UltiSnips#JumpBackwards()<CR>")
        elseif cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      { "i", "s" }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'}),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'}),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
            return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
          end

          cmp.select_next_item()
        elseif has_words_before() then
          press("<Space>")
        else
          fallback()
        end
      end,
      {"i", "s"}
    ),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({select = true})
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'ultisnips' },
    { name = 'buffer' }
  },

  formatting = {
    format = require("lspkind").cmp_format({with_text = true, menu = ({
      buffer = "[Buffer]",
      nvim_lsp = "[LSP]",
      nvim_lua = "[api]",
      ultisnips = "[snips]",
      path = "[Path]",
    })})
  }
})

vim.cmd'let g:lexima_no_default_rules = v:true'
vim.cmd'call lexima#set_default_rules()'
