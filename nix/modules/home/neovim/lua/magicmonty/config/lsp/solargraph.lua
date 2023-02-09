local M = {}

M.opts = {
  single_file_support = true,
  on_init = function(client)
    local has_sonicpi, sonicpi = pcall(require, 'sonicpi')
    if has_sonicpi then
      sonicpi.lsp_on_init(client, { server_dir = '/opt/sonic-pi/app/server' })
    end
  end,
  filetypes = { 'ruby', 'sonicpi' },
  settings = {
    solargraph = {
      autoformat = true,
      diagnostics = true,
      formatting = true,
    }
  }
}

return M
