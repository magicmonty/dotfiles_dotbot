local dap = require('dap')
local dapui = require('dapui')

require('nvim-dap-virtual-text').setup()

dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = { '--interpreter=vscode' },
  options = {
    env = {
      ASPNETCORE_ENVIRONMENT = 'Development',
      cwd = '${workspaceFolder}',
    },
  },
}

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
  {
    type = 'netcoredbg',
    name = 'attach - netcoredbg',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
}

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end
