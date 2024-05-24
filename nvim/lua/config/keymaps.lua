-- Navigate with Alt+h/j/k/l
vim.cmd("let g:tmux_navigator_no_mappings = 1")
vim.cmd("noremap <silent> <A-h> :<C-U>TmuxNavigateLeft<cr>")
vim.cmd("noremap <silent> <A-j> :<C-U>TmuxNavigateDown<cr>")
vim.cmd("noremap <silent> <A-k> :<C-U>TmuxNavigateUp<cr>")
vim.cmd("noremap <silent> <A-l> :<C-U>TmuxNavigateRight<cr>")
-- vim.cmd('noremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>')

-- Telescope
local builtin = require("telescope.builtin")
-- todo: Figure out how to get whichkey to take intermediate prompts
-- vim.keymap.set('n', '<leader>f',{desc="Telescope cmds"})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, { noremap = true })

-- Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Open Neotree (Focus File)" })
vim.keymap.set(
	"n",
	"<leader>E",
	":Neotree toggle reveal=false filesystem reveal left<CR>",
	{ desc = "Toggle Neotree (Prev Position)" }
)
-- LSP diagnostics
vim.keymap.set("n", "<space>do", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>d[", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<space>d]", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<space>dt", "<Plug>(toggle-lsp-diag-vtext)", { desc = "Toggle Diagnostic Text" })
vim.keymap.set("n", "<space>dk", "<Plug>(toggle-lsp-diag-off)", { desc = "Kill Diagnostics" })
vim.keymap.set("n", "<space>dr", "<Plug>(toggle-lsp-diag-on)", { desc = "Restart Diagnostic" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>dd",
	"<cmd>Telescope diagnostics<CR>",
	{ noremap = true, silent = true, desc = "View All Diagnostics" }
)

-- TODO: Need to finish completion toggles (move to this file)

-- Code Jumping
-- local opts = { buffer = ev.buf }
vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation, {})
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {desc = "references"})
vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "references" })
vim.keymap.set("n", "H", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
-- vim.keymap.set("n", "<space>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, {})
vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})

-- Formating
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Code" }) -- async = true
