-- General Vim Settings

-- Tabs
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")

-- Better searching
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

-- Change to new split to be where it the good lord intended
vim.cmd("set splitbelow")
vim.cmd("set splitright")

-- make the vim leader key "space bar"
vim.g.mapleader = " "

-- Make copy+paste system level
vim.cmd("set clipboard=unnamedplus")

-- force stop tmux_navigator plugin from auto remapping commands before it even runs
vim.cmd("let g:tmux_navigator_no_mappings = 1")
