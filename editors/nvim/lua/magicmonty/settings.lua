local vim_ext = require("vim_ext")
local cmd = vim.cmd
local opt = vim.opt

--
-- Fundamentals
-- ------------

-- Map the leader key to <space>
vim_ext.map('n', '<space>', '', {})
vim.g.mapleader = " "

vim_ext.init_autocmd()

opt.guifont = "Monoid NF:h16"
opt.compatible = false
opt.number = true
opt.relativenumber = true
opt.title = true
opt.autoindent = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = false
opt.hlsearch = true
opt.showcmd = false
opt.expandtab = true
opt.ruler = false
opt.showmatch = false
opt.showmode = false
opt.modeline = true

cmd "syntax enable"
opt.fileencodings = { "utf-8", "latin" }
opt.fileencoding = "utf-8"
opt.fileformats = { "unix", "dos" }
opt.encoding = "utf-8"
opt.bomb = false
opt.background = "dark"
opt.cmdheight = 1
opt.laststatus = 2
opt.scrolloff = 10

-- incremental substitution (neovim)
opt.inccommand = "split"

-- Suppress appending <PasteStart> and <PasteEnd> when pasting
cmd "set t_BE="

-- Don't redraw while executing macros (good performance config)
opt.lazyredraw = true

-- Ignore case when searching
opt.ignorecase = true
opt.smartcase = true

-- Be smart when using tabs ;)
opt.smarttab = true

-- indents
cmd "filetype plugin indent on"

opt.shiftwidth = 2
opt.shiftround = true -- Round indent to a multiple of 'shiftwidth'.
opt.tabstop = 2
opt.softtabstop = 2 -- Edit as if tabs are 2 characters wide.
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.backspace = "eol,indent,start"

-- Finding files - Search down into subfolders
opt.path = opt.path + "**"
opt.wildignore = opt.wildignore + "*/node_modules/*"
opt.wildignore = opt.wildignore + "*/.git/*"
opt.wildignore = opt.wildignore + "*/tmp/*"
opt.wildignore = opt.wildignore + "*/.fake/*"
opt.wildignore = opt.wildignore + "*.swp"

-- Turn off paste mode when leaving insert
vim_ext.au({"InsertLeave", "*", "set nopaste"})

-- Add asterisks in block comments
opt.formatoptions = opt.formatoptions + "r"

-- Turn 'list' off by default, since it interferes with 'linebreak' and
-- 'breakat' formatting (and it's ugly and noisy), but define characters to use
-- when it's turned on.
opt.list = false
opt.listchars = { tab = ">-", trail = ".", extends = ">", precedes = "<", eol = "$" }

-- Enable mouse support
opt.mouse = "a"

-- Splits
opt.splitright = true -- Split new vertical windows right of current window.
opt.splitbelow= true -- Split new horizontal windows under current window.

-- Neovide specific settings
vim.g.neovide_transparency = 0.8

-- copilot settings
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

