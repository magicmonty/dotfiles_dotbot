local status, dap = pcall(require, 'dap')
if not status then return end

dap.adapters.netcoredbg = {
  type = 'executable',
  command = 'netcoredbg',
  args = {
    '--interpreter=vscode'
  }
}

dap.configurations.cs = {
  {
    type = 'netcoredbg',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd()..'/bin/Debug/', 'file')
    end
  },
  {
    type = 'netcoredbg',
    name = 'attach - netcoredbg',
    request = 'attach',
    processId = require('dap.utils').pick_process
  }
}

