local status, _ = pcall(require, 'lsp-status')
if not status then return end
local diagnostics = require('lsp-status/diagnostics')
local messages = require('lsp-status/messaging').messages
local aliases = {pyls_ms = 'MPLS'}
local hi = require'vim_ext'.hi

hi('LualineDiagnosticError', { guifg = '#c94f6d', guibg = "#131a24" })
hi('LualineDiagnosticWarn', { guifg = '#dbc074', guibg = "#131a24" })
hi('LualineDiagnosticInfo', { guifg = '#719cd6', guibg = "#131a24" })
hi('LualineDiagnosticHint', { guifg = '#63cdcf', guibg = "#131a24" })
hi('LualineDiagnosticOk', { guifg = '#58cd8b', guibg = "#131a24" })

local config = {
  show_current_function = true,
  spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
  component_separator = ' ',
  diagnostics = {
    enabled = true,
    separator = ' ',
    error = {
      icon = '',
      highlight = 'LualineDiagnosticError'
    },
    warning = {
      icon = '',
      highlight = 'LualineDiagnosticWarn'
    },
    info = {
      icon = '',
      highlight = 'LualineDiagnosticInfo'
    },
    hint = {
      icon = '',
      highlight = 'LualineDiagnosticHint'
    },
    ok = {
      icon = '',
      highlight = 'LualineDiagnosticOk'
    }
  }
}

local function get_lsp_progress()
  local buf_messages = messages()
  local msgs = {}

  for _, msg in ipairs(buf_messages) do
    local name = aliases[msg.name] or msg.name
    local client_name = '[' .. name .. ']'
    local contents
    if msg.progress then
      contents = msg.title
      if msg.message then contents = contents .. ' ' .. msg.message end

      -- this percentage format string escapes a percent sign once to show a percentage and one more
      -- time to prevent errors in vim statusline's because of it's treatment of % chars
      if msg.percentage then contents = contents .. string.format(" (%.0f%%%%)", msg.percentage) end

      if msg.spinner then
        contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1] .. ' ' .. contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then filename = vim.fn.pathshorten(filename) end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end
  return table.concat(msgs, config.component_separator)
end

local function get_lsp_statusline(bufnr)
  bufnr = bufnr or 0
  if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then return '' end
  local buf_diagnostics = diagnostics(bufnr) or nil
  local only_hint = true
  local some_diagnostics = false
  local status_parts = {}
  if buf_diagnostics then
    if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
      table.insert(status_parts,
        '%#' .. config.diagnostics.error.highlight .. '#' .. config.diagnostics.error.icon .. config.diagnostics.separator .. buf_diagnostics.errors)
      only_hint = false
      some_diagnostics = true
    end

    if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
      table.insert(status_parts,
        '%#' .. config.diagnostics.warning.highlight .. '#' .. config.diagnostics.warning.icon .. config.diagnostics.separator ..
        buf_diagnostics.warnings)
      only_hint = false
      some_diagnostics = true
    end

    if buf_diagnostics.info and buf_diagnostics.info > 0 then
      table.insert(status_parts,
        '%#' .. config.diagnostics.info.highlight .. '#' .. config.diagnostics.info.icon .. config.diagnostics.separator .. buf_diagnostics.info)
      only_hint = false
      some_diagnostics = true
    end

    if buf_diagnostics.hints and buf_diagnostics.hints > 0 then
      table.insert(status_parts,
        '%#' .. config.diagnostics.hint.highlight .. '#' .. config.diagnostics.hint.icon .. config.diagnostics.separator .. buf_diagnostics.hints)
      some_diagnostics = true
    end
  end

  local msgs = get_lsp_progress()

  local base_status = vim.trim(table.concat(status_parts, config.component_separator) .. ' ' .. msgs)
  local symbol = (some_diagnostics and only_hint) and '' or ' '
  if config.show_current_function then
    local current_function = vim.b.lsp_current_function
    if current_function and current_function ~= '' then
      symbol = symbol .. '(' .. current_function .. ')' .. config.component_separator
    end
  end

  if base_status ~= '' then return symbol .. base_status .. ' ' end
  if not config.diagnostics.enabled then return symbol end
  return symbol .. '%#' .. config.diagnostics.ok.highlight .. '#' .. config.diagnostics.ok.icon .. ' '
end

local M = {
  status = get_lsp_statusline
}

return M
