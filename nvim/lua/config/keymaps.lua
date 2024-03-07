-- Navigate with Alt+h/j/k/l
vim.cmd("noremap <A-h> <C-w>h")
vim.cmd("noremap <A-j> <C-w>j")
vim.cmd("noremap <A-k> <C-w>k")
vim.cmd("noremap <A-l> <C-w>l")

-- Telescope
local builtin = require("telescope.builtin")
-- vim.keymap.set('n', '<leader>f',{desc="Telescope cmds"})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, { noremap = true })

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem reveal left<CR>", { desc = "Open Neotree" })

-- LSP hover docs
-- vim.keymap.set('n', '<space>1', vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
-- local opts = { buffer = ev.buf }
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
vim.keymap.set("n", "<space>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, {})
vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<space>f", function()
	vim.lsp.buf.format({ async = true })
end, {})

-- Formating
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
