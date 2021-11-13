-- vim: foldlevel=99:
local utils = require('telescope.utils')

local M = {}

M.search_config = function()
  local opts = {
    cwd = '~/.dotfiles/editors/nvim',
    prompt_title = "NVIM Config",
    path_display = {
      'absolute'
    }
  }

  require('telescope.builtin').find_files(opts)
end

M.project_files = function()
  local _, ret, _ = utils.get_os_command_output {
    "git",
    "rev-parse",
    "--is-inside-work-tree",
  }

  local gopts = {}
  local fopts = {}

  gopts.prompt_title = " Git Files"
  gopts.prompt_prefix = "  "
  gopts.results_title = "Project Files Results"

  fopts.hidden = true
  fopts.follow = true

  fopts.file_ignore_patterns = {
    ".vim/",
    ".local/",
    ".cache/",
    "Downloads/",
    ".git/",
    "Dropbox/.*",
    "Library/.*",
    ".rustup/.*",
    "Movies/",
    ".cargo/registry/",
  }

  if ret == 0 then
    require("telescope.builtin").git_files(gopts)
  else
    require("telescope.builtin").find_files(fopts)
  end
end

return M
