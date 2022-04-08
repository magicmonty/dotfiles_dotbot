local hi = require('vim_ext').hi
local theme = require('magicmonty.theme')
local colors = theme.colors
local icons = theme.icons.diagnostics

hi('LualineDiagnosticError', { guifg = colors.diag.error, guibg = colors.bg0 })
hi('LualineDiagnosticWarn', { guifg = colors.diag.warn, guibg = colors.bg0 })
hi('LualineDiagnosticInfo', { guifg = colors.diag.info, guibg = colors.bg0 })
hi('LualineDiagnosticHint', { guifg = colors.diag.hint, guibg = colors.bg0 })
hi('LualineDiagnosticOk', { guifg = colors.palette.green.bright, guibg = colors.bg0 })

local config = {
  spinner_frames = theme.icons.spinner.frames,
  component_separator = ' ',
  diagnostics = {
    separator = ' ',
    error = {
      icon = icons.Error,
      highlight = 'LualineDiagnosticError',
    },
    warning = {
      icon = icons.Warning,
      highlight = 'LualineDiagnosticWarn',
    },
    info = {
      icon = icons.Information,
      highlight = 'LualineDiagnosticInfo',
    },
    hint = {
      icon = icons.Hint,
      highlight = 'LualineDiagnosticHint',
    },
    ok = {
      icon = icons.Ok,
      highlight = 'LualineDiagnosticOk',
    },
  },
}

local function hl(highlight_name)
  return '%#' .. highlight_name .. '#'
end

local function hl_icon(icon_config)
  return hl(icon_config.highlight) .. icon_config.icon
end

local function get_lsp_status_icon(bufnr)
  local msgs = {}

  if vim.lsp.util.get_progress_messages()[1] then
    return hl_icon(config.diagnostics.ok)
  else
    if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then
      return config.diagnostics.error.icon
    else
      return hl_icon(config.diagnostics.ok)
    end
  end

  return vim.trim(table.concat(msgs, config.component_separator))
end

local function insert_diag_part(status_parts, count, cfg)
  if count and count > 0 then
    table.insert(status_parts, hl_icon(cfg) .. config.diagnostics.separator .. count)
  end
end

local function count_diagnostics(diagnostics, severity)
  local count = 0
  for _, diag in ipairs(diagnostics) do
    if diag.severity == severity then
      count = count + 1
    end
  end

  return count
end

local function get_diagnostics_parts(bufnr)
  local status_parts = {}

  local buf_diagnostics = vim.diagnostic.get(bufnr) or nil
  local cfg = config.diagnostics

  if buf_diagnostics then
    insert_diag_part(status_parts, count_diagnostics(buf_diagnostics, vim.diagnostic.severity.ERROR), cfg.error)
    insert_diag_part(status_parts, count_diagnostics(buf_diagnostics, vim.diagnostic.severity.WARN), cfg.warning)
    insert_diag_part(status_parts, count_diagnostics(buf_diagnostics, vim.diagnostic.severity.INFO), cfg.info)
    insert_diag_part(status_parts, count_diagnostics(buf_diagnostics, vim.diagnostic.severity.HINT), cfg.hint)
  end

  return status_parts
end

local function get_lsp_statusline(bufnr)
  bufnr = bufnr or 0
  if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then
    return config.diagnostics.error.icon
  end

  local status_parts = get_diagnostics_parts(bufnr)
  local msgs = get_lsp_status_icon(bufnr)

  local base_status = vim.trim(msgs .. '  ' .. table.concat(status_parts, config.component_separator))
  local symbol = ''

  if base_status ~= '' then
    return symbol .. base_status .. config.component_separator
  end

  return symbol
end

local M = {
  status = get_lsp_statusline,
}

return M
