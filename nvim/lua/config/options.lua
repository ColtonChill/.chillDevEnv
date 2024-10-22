-- General Vim Settings
-- Better line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Better searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Change to new split to be where it the good lord intended (down/right)
vim.opt.splitbelow = true
vim.opt.splitright = true

-- make the vim leader key "space bar"
vim.g.mapleader = " "

-- Make copy+paste system level
vim.opt.clipboard = "unnamedplus"

-- TreeSitter assisted folding
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- force stop tmux_navigator plugin from auto remapping commands before it even runs
-- vim.cmd("let g:tmux_navigator_no_mappings = 1")
vim.g.tmux_navigator_no_mappings = 1
