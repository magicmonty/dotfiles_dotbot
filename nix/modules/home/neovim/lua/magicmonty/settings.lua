-- [[ Setting options ]]
-- See `:help vim.o`

vim.opt.guifont = "JetBrains Mono NF:h12"
-- Don't highlight every search result on search
vim.opt.hlsearch = false
-- but highlight current search result while creating search term
vim.opt.incsearch = true

-- hide cmd line unless used
vim.opt.cmdheight = 0

-- Make line numbers default
vim.wo.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.backspace = 'eol,indent,start'

-- Decrease update time
vim.opt.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.opt.termguicolors = true
vim.opt.guicursor = ''
vim.opt.winblend = 0
vim.opt.pumblend = 5

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- No linewrapping
vim.opt.wrap = false

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nicer netrw display
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Tabstops
local tab_width
vim.opt.tabstop = tab_width
vim.opt.softtabstop = tab_width
vim.opt.shiftwidth = tab_width
vim.opt.expandtab = true

-- No Swap/Backup files
vim.opt.swapfile = false
vim.opt.backup = false
-- preserver undo tree on exit
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.isfname:append('@-@')

--- time it takes for CursorHold to fire
vim.opt.updatetime = 50
vim.opt.colorcolumn = '120'

vim.opt.bomb = false
vim.opt.fileencodings = { 'utf-8', 'latin' }
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos' }
vim.opt.encoding = 'utf-8'

vim.opt.laststatus = 3

-- Finding files - Search down into subfolders
vim.opt.path = vim.opt.path + '**'
vim.opt.wildignore = vim.opt.wildignore + '*/node_modules/*'
vim.opt.wildignore = vim.opt.wildignore + '*/.git/*'
vim.opt.wildignore = vim.opt.wildignore + '*/tmp/*'
vim.opt.wildignore = vim.opt.wildignore + '*.swp'

-- Add asterisks in block comments
vim.opt.formatoptions = vim.opt.formatoptions + 'r'

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Neovide specific settings
vim.g.neovide_transparency = 0.8
