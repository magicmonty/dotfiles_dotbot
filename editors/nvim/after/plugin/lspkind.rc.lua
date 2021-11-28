local status,lspkind = pcall(require, "lspkind")
if not status then return end

lspkind.init({
  -- enable text annotations
  with_text = true,

  -- use nerd fonts for icons
  preset = 'default',

  -- set symbols
  symbol_map = {
    Text = "",
    Method = "",
    Function = '',
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = '',
    Interface = 'I',
    Module = "",
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Reference = '',
    Folder = "",
    EnumMember = '',
    Constant = '',
    Struct = "פּ",
    Event = '',
    Operator = "",
    TypeParameter = ''
  }
})
