local installed, sonicpi = pcall(require, 'sonicpi')
if not installed then return end

sonicpi.setup({ server_dir = '/opt/sonic-pi/app/server' })

