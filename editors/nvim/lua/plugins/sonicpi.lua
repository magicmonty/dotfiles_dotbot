return {
  '~/src/plugins/sonicpi.nvim',
  dev = true,
  cond = vim.fn.isdirectory(vim.fn.glob('~/src/plugins/sonicpi.nvim')),
  dependencies = { 'webdevicons' },
  config = function()
    local installed, sonicpi = pcall(require, "sonicpi")
    if not installed then return end

    sonicpi.setup { server_dir = '/opt/sonic-pi/app/server' }
  end
}
