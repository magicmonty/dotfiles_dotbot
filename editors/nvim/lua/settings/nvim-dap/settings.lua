local dap = require('dap')

require('nvim-dap-virtual-text').setup()

dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.netcoredbg = {
  type = 'executable',
  command = 'netcoredbg',
  args = {
    '--interpreter=vscode',
  },
  options = {
    env = {
      ASPNETCORE_ENVIRONMENT = 'Development',
      cwd = '${workspaceFolder}',
    },
  },
}

dap.configurations.cs = {
  {
    type = 'netcoredbg',
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
