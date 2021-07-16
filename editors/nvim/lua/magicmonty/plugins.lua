local Plug = function(name, opts)
  local command = "Plug '" .. name .. "'"
  if opts then
    command = command .. ", {"
    for k, v in pairs(opts) do
      command = command .. "'" .. k .. "': '" .. v .. "'"
    end

    command = command .. "}"
  end

  vim.cmd(command)
end

vim.cmd "call plug#begin('~/.config/nvim-data/plugged')"

-- Git support
Plug 'tpope/vim-fugitive'

-- Bracket auto closing
Plug 'cohama/lexima.vim'

-- Color scheme
Plug 'drewtempelmeyer/palenight.vim'

-- Nice status line
Plug 'hoob3rt/lualine.nvim'

-- Auto comment line
Plug 'tpope/vim-commentary'

-- LSP/Completion config
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'nvim-lua/completion-nvim'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug('groenewege/vim-less', { ['for'] = 'less' })

vim.cmd "call plug#end()"

