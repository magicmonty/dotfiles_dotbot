local M = {}

M.opts = {
  settings = {
    texlab = {
      auxDirectory = "./out",
      build = {
        onSave = true,
        forwardSearchAfter = true,
        executable = 'latexmk',
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=./out", "-shell-escape", "%f" }
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
