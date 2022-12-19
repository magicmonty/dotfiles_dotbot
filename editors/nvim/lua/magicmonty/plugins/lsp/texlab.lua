local M = {}

M.opts = {
  settings = {
    texlab = {
      build = {
        onSave = true,
        forwardSearchAfter = true,
      },
      forwardSearch = {
        executable = 'zathura',
        args = { '--synctex-forward', '%l:1:%f', '%p' }
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true
      }
    }
  }
}

return M
