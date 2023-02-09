local M = {}

M.decode = function()
  vim.cmd([[ :'<,'>!jq -R 'split(".") | .[1] | @base64d | fromjson' ]])
end

return M
