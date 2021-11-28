local status, lualine = pcall(require, 'lualine')
if not status then
  return
end

local tabline = require('tabline')
tabline.setup({
  options = {
    show_filename_only = true,
  },
})

local function LspStatus()
  status = ''
  if vim.lsp.buf_get_clients() then
    status = require('magicmonty.lsp-status').status()
  end

  return status
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = 'nightfox',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = {
      LspStatus,
      'encoding',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { 'fugitive' },
})
