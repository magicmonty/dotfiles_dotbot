local dap = require('dap')
local dapui = require('dapui')

require('nvim-dap-virtual-text').setup()

dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.coreclr = {
  type = 'executable',
  command = '/usr/bin/netcoredbg',
  args = {
    '--interpreter=vscode',
    string.format('--engineLogging=%s/netcoredbg.engine.log', os.getenv('XDG_CACHE_HOME')),
    string.format('--log=%s/netcoredbg.log', os.getenv('XDG_CACHE_HOME')),
  },
  env = function()
    return {
      ASPNETCORE_ENVIRONMENT = 'Development',
    }
  end,
}

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      local dll = io.popen('find . -name "*.dll" | grep -v obj')
      -- return vim.fn.getcwd() .. '/' .. dll:lines()()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
    stopAtEntry = true,
  },
}

dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end
