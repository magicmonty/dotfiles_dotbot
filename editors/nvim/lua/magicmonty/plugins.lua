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
Plug 'hrsh7th/nvim-compe'

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('nvim-treesitter/nvim-treesitter-refactor')
Plug('p00f/nvim-ts-rainbow')

-- Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'fhill2/telescope-ultisnips.nvim'

Plug('groenewege/vim-less', { ['for'] = 'less' })

-- Clojure / Overtone
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-sexp'

vim.cmd "call plug#end()"

