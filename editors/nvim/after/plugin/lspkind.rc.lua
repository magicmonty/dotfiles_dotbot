local status,lspkind = pcall(require, "lspkind")
if not status then return end

lspkind.init({
  with_text = true,
  preset = 'default',
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
