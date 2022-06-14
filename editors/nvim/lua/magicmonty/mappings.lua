local M = {}
local has_wk, wk = pcall(require, 'which-key')

local function register_with_prefix(mappings, prefix, opts)
  if type(mappings) ~= 'table' then
    return
  end

  -- remove name as it is not needed for the fallback
  if mappings.name then
    mappings['name'] = nil
  end

  if table.maxn(mappings) > 0 then
    local firstElement = mappings[1]
    local firstElementType = type(firstElement)
    if firstElementType == 'string' or firstElementType == 'function' then
      local mode = (opts and opts.mode) or 'n'
      if opts and opts.mode then
        opts.mode = nil
      end

      vim.keymap.set(mode, prefix, firstElement, opts)
    end
  end

  for key, mapping in pairs(mappings) do
    register_with_prefix(mapping, prefix .. key, opts)
  end
end

local function register_fallback(mappings, opts)
  local prefix = (opts and opts.prefix) or ''
  if prefix then
    -- remove prefix key from opts table
    opts['prefix'] = nil
  end

  for key, mapping in pairs(mappings) do
    register_with_prefix(mapping, prefix .. key, opts)
  end
end

M.register = function(mappings, opts)
  if has_wk then
    wk.register(mappings, opts)
  else
    register_fallback(mappings, opts)
  end
end

return M
