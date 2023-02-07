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
        args = {
          '-x', 'nvr --servername /home/mgondermann/.cache/nvim/server.pipe --remote-silent +%{line} %{input}',
          '--synctex-forward',
          '%l:1:%f',
          '%p',
        }
        -- executable = 'okular',
        -- args = { '--unique', 'file:%p#src:%l%f' }
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true
      }
    }
  }
}

return M
