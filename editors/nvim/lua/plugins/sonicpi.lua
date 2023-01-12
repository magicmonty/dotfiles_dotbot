return {
  'magicmonty/sonicpi.nvim',
  dev = true,
  dependencies = { 'webdevicons' },
  ft = { "sonicpi" },
  config = function()
    require('sonicpi').setup { server_dir = '/opt/sonic-pi/app/server' }
  end
}
