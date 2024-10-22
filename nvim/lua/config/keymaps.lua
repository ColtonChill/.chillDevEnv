-- whichkey intermediate descriptions
local whichKey = require("which-key")

-- Navigate with Alt+h/j/k/l
vim.cmd("let g:tmux_navigator_no_mappings = 1")
vim.cmd("noremap <silent> <A-h> :<C-U>TmuxNavigateLeft<cr>")
vim.cmd("noremap <silent> <A-j> :<C-U>TmuxNavigateDown<cr>")
vim.cmd("noremap <silent> <A-k> :<C-U>TmuxNavigateUp<cr>")
vim.cmd("noremap <silent> <A-l> :<C-U>TmuxNavigateRight<cr>")
-- vim.cmd('noremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>')

-- Splits (windows)
vim.keymap.set("n", "<leader>s", "<cmd>vsplit<cr>")
vim.keymap.set("n", "<leader>S", "<cmd>split<cr>")
-- Tabs
whichKey.register({ ["<leader>t"] = { name = "Tabs" } })
vim.keymap.set("n", "<leader>tc", "<cmd>tabnew<cr>")
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabNext<cr>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>")

--vim.keymap.set("n", "<leader>S", ":bnext<CR>', { noremap = true, silent = true })
--':bprevious<CR>', { noremap = true, silent = true })

-- Telescope (quick lookup pop-out)
local builtin = require("telescope.builtin")
whichKey.register({ ["<leader>f"] = { name = "Find" } })
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, { noremap = true })

-- Neo-tree (file explorer)
vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Open Files" })
vim.keymap.set("n", "<leader>b", ":Neotree buffers<CR>", { desc = "Open Buffers" })
vim.keymap.set("n", "<leader>E", ":Neotree close<CR>", { desc = "Close Neotree" })

-- Code Jumping
-- local opts = { buffer = ev.buf }
vim.keymap.set("n", "<leader>jD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "<leader>jd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>ji", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<leader>jr", vim.lsp.buf.references, { desc = "references" })
vim.keymap.set("n", "<leader>jR", require("telescope.builtin").lsp_references, { desc = "references" })
vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- Formatting
whichKey.register({ ["<leader>c"] = { name = "Code Stuff" } })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Code" }) -- async = true

-- auto-actions
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- LSP auto-completion
-- TODO: Move auto-complete keymaps here

-- LSP diagnostics
-- dk  up
-- dj  down
-- vim.diagnostic.severity.ERROR
-- vim.diagnostic.severity.WARN
-- vim.diagnostic.severity.INFO
-- vim.diagnostic.severity.HINT
local signs_enabled = true
local underline_enabled = true
local virtual_text_enabled = true
-- toggle ALL diagnostic
whichKey.register({ ["<leader>d"] = { name = "Diagnostics" } })
vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })
-- open pop up window
vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, {
  desc = "Open diagnostic detail window",
})
-- jump to previous error
vim.keymap.set("n", "<leader>dN", vim.diagnostic.goto_prev, {
  desc = "Goto previous diagnostic warning",
})
-- jump to next error
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {
  desc = "Goto next diagnostic warning",
})
-- toggle diagnostics functions
local diagnostic_toggles = {
  signs = true,
  underline = true,
  virtual_text = true,
}
local function make_diag_toggle(key, label)
  return function()
    diagnostic_toggles[key] = not diagnostic_toggles[key]
    vim.diagnostic.config({ [key] = diagnostic_toggles[key] })
    print(string.format("LSP %s %s", label, diagnostic_toggles[key] and "enabled" or "disabled"))
  end
end
-- toggle diagnostic signs
vim.keymap.set("n", "<leader>ds", make_diag_toggle("signs", "signs"), {
  desc = "Toggle diagnostic margin signs",
})
-- toggle diagnostic underlines
vim.keymap.set("n", "<leader>du", make_diag_toggle("underline", "underlines"), {
  desc = "Toggle diagnostic underlines",
})
-- toggle diagnostic text
vim.keymap.set("n", "<leader>dt", make_diag_toggle("virtual_text", "virtual text"), {
  desc = "Toggle diagnostic virtual text",
})

-- toggle diagnostic unicode
-- vim.keymap.set("n", "<leader>dk", "<Plug>(toggle-lsp-diag-off)", { desc = "Kill diagnostics" })
-- vim.keymap.set("n", "<leader>da", "<Plug>(toggle-lsp-diag-on)", { desc = "Turn on ALL diagnostics" })
-- vim.keymap.set("n", "<leader>dd", "<Plug>(toggle-lsp-diag)", { desc = "Toggle diagnostic" })
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>dD",
-- 	"<cmd>Telescope diagnostics<CR>",
-- 	{ noremap = true, silent = true, desc = "View ALL diagnostics" }
-- )

-- TreeSitter (incremental_selection)
local inc_sel = require("nvim-treesitter.incremental_selection")
whichKey.register({ ["<leader>v"] = { name = "Incremental Selection" } })
vim.keymap.set({ "n", "v" }, "<leader>vv", inc_sel.init_selection, { desc = "Init selection" })
vim.keymap.set({ "n", "v" }, "<leader>vn", inc_sel.node_incremental, { desc = "Increment node" })
vim.keymap.set({ "n", "v" }, "<leader>vc", inc_sel.scope_incremental, { desc = "Increment scope" })
vim.keymap.set({ "n", "v" }, "<leader>vN", inc_sel.node_decremental, { desc = "Decrement node" })

-- Code Folding (ufo)
vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Open all folds" })
vim.keymap.set("n", "zh", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = "Peek Fold" })

-- Spell Checking
whichKey.register({ ["<leader>."] = { name = "Spell Checking" } })
vim.keymap.set("n", "<leader>..", function()
  -- toggle only the local window spelling
  vim.wo.spell = not vim.wo.spell
  print("Spell checking " .. (vim.wo.spell and "enabled" or "disabled"))
end, { desc = "Toggle spell checking" })

-- vim.keymap.set('n', '<leader>.c', {})
-- vim.keymap.set('n', '<leader>.c', function()
--   local word = vim.fn.expand('<cword>')
--   local suggestions = vim.fn.spellsuggest(word)
--
--   if #suggestions == 0 then
--     print("No suggestions")
--     return
--   end
--
--   local lines = { "Suggestions for: " .. word }
--   for i, s in ipairs(suggestions) do
--     table.insert(lines, i .. ". " .. s)
--   end
--
--   vim.lsp.util.open_floating_preview(lines, "plaintext", {
--     border = "rounded",
--   })
-- end, { desc = "Popup spelling suggestions" })
