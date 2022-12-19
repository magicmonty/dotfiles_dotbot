local M = {}

M.opts = {
  settings = {
    omnisharp = {
      enable_roslyn_analyzers = true,
      organize_imports_on_format = true,
      enable_import_completion = true,
    }
  }
}

return M
