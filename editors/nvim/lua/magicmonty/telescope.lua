-- vim: foldlevel=99:
local exports = {}

exports.search_config = function()
  local opts = {
    cwd = '~/.config/nvim',
    path_display = {
      'absolute'
    }
  }

  require('telescope.builtin').find_files(opts)
end

return exports 
