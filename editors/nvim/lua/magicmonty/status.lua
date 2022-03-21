local status, _ = pcall(require, 'lsp-status')
if not status then
  return
end
local diagnostics = require('lsp-status/diagnostics')
local messages = require('lsp-status/messaging').messages
local hi = require('vim_ext').hi
local theme = require('magicmonty.theme')
local colors = theme.colors
local icons = theme.icons.diagnostics

hi('LualineDiagnosticError', { guifg = colors.spec.diag.error, guibg = colors.spec.bg0 })
hi('LualineDiagnosticWarn', { guifg = colors.spec.diag.warn, guibg = colors.spec.bg0 })
hi('LualineDiagnosticInfo', { guifg = colors.spec.diag.info, guibg = colors.spec.bg0 })
hi('LualineDiagnosticHint', { guifg = colors.spec.diag.hint, guibg = colors.spec.bg0 })
hi('LualineDiagnosticOk', { guifg = colors.pallet.green.bright, guibg = colors.spec.bg0 })

local config = {
  show_current_function = false,
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

local function get_lsp_progress(bufnr)
  local buf_messages = messages()
  local msgs = {}

  local clients = {}
  local unique_buf_messages = {}
  for _, msg in ipairs(buf_messages) do
    if not clients[msg.name] then
      clients[msg.name] = true
      table.insert(unique_buf_messages, msg)
    end
  end
  buf_messages = unique_buf_messages

  for _, msg in ipairs(buf_messages) do
    local contents = ''
    if msg.progress then
      if msg.spinner then
        contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1]
      else
        contents = hl_icon(config.diagnostics.ok)
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, contents)
  end

  if #msgs == 0 then
    local msg = vim.lsp.util.get_progress_messages()[1]
    if msg then
      table.insert(msgs, hl_icon(config.diagnostics.ok))
    else
      if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then
        table.insert(msgs, config.diagnostics.error.icon)
      else
        table.insert(msgs, hl_icon(config.diagnostics.ok))
      end
    end
  end

  return vim.trim(table.concat(msgs, config.component_separator))
end

local function insert_diag_part(status_parts, count, cfg)
  if count and count > 0 then
    table.insert(status_parts, hl_icon(cfg) .. config.diagnostics.separator .. count)
  end
end

local function get_diagnostics_parts(bufnr)
  local status_parts = {}

  local buf_diagnostics = diagnostics(bufnr) or nil
  local cfg = config.diagnostics

  if buf_diagnostics then
    insert_diag_part(status_parts, buf_diagnostics.errors, cfg.error)
    insert_diag_part(status_parts, buf_diagnostics.warnings, cfg.warning)
    insert_diag_part(status_parts, buf_diagnostics.info, cfg.info)
    insert_diag_part(status_parts, buf_diagnostics.hints, cfg.hint)
  end

  return status_parts
end

local function get_lsp_statusline(bufnr)
  bufnr = bufnr or 0
  if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then
    return config.diagnostics.error.icon
  end

  local status_parts = get_diagnostics_parts(bufnr)
  local msgs = get_lsp_progress(bufnr)

  local base_status = vim.trim(msgs .. '  ' .. table.concat(status_parts, config.component_separator))
  local symbol = ''
  if config.show_current_function then
    local current_function = vim.b.lsp_current_function
    if current_function and current_function ~= '' then
      symbol = '(' .. current_function .. ')' .. config.component_separator
    end
  end

  if base_status ~= '' then
    return symbol .. base_status .. config.component_separator
  end

  return symbol
end

local M = {
  status = get_lsp_statusline,
}

return M
