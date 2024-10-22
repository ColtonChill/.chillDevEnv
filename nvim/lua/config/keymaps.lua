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
whichKey.add({
  { "<leader>t",  group = "Tabs" },
  { "<leader>tc", "<cmd>tabnew<cr>",      desc = "Create a new tab", mode = "n" },
  { "<leader>tq", "<cmd>tabclose<cr>",    desc = "Close tab",        mode = "n" },
  { "<leader>tn", "<cmd>tabnext<cr>",     desc = "Next tab",         mode = "n" },
  { "<leader>tp", "<cmd>tabprevious<cr>", desc = "Prev tab",         mode = "n" },
})

--vim.keymap.set("n", "<leader>S", ":bnext<CR>', { noremap = true, silent = true })
--':bprevious<CR>', { noremap = true, silent = true })

-- Telescope (quick lookup pop-out)
local builtin = require("telescope.builtin")
whichKey.add({
  { "leader>f",   group = "Find" },
  { "<leader>ff", builtin.find_files, desc = "Find file name",       mode = "n" },
  { "<leader>fg", builtin.live_grep,  desc = "Find file contents",   mode = "n" },
  { "<leader>fb", builtin.buffers,    desc = "Find name in buffers", mode = "n" },
  { "<leader>fh", builtin.help_tags,  desc = "Find help tags",       mode = "n" },
  { "<leader>fr", builtin.resume,     desc = "Resume Find",          mode = "n" },
})

-- Neo-tree (file explorer)
whichKey.add({
  { "<leader>e", ":Neotree filesystem reveal left<CR>", desc = "Open Files",    mode = "n" },
  { "<leader>b", ":Neotree buffers<CR>",                desc = "Open Buffers",  mode = "n" },
  { "<leader>E", ":Neotree close<CR>",                  desc = "Close Neotree", mode = "n" },
})

-- Code Jumping
whichKey.add({
  { "leader>j",   group = "Jump" },
  { "<leader>jD", vim.lsp.buf.declaration,     desc = "Jump to declaration",    mode = "n" },
  { "<leader>jd", vim.lsp.buf.definition,      desc = "Jump to definition",     mode = "n" },
  { "<leader>ji", vim.lsp.buf.implementation,  desc = "Jump to implementation", mode = "n" },
  { "<leader>jr", builtin.lsp_references,      desc = "Jump to references" },
  { "<leader>h",  vim.lsp.buf.hover,           desc = "Open hover text",        mode = "n" },
  { "<leader>k",  vim.lsp.buf.signature_help,  desc = "Open signature help",    mode = "n" },
  { "<leader>D",  vim.lsp.buf.type_definition, desc = "Open type def help",     mode = "n" },
  { "<leader>rn", vim.lsp.buf.rename,          desc = "rename refactor",        mode = "n" },
})

-- Formatting
whichKey.add({
  { "<leader>c",  group = "Code Manipulation" },
  { "<leader>cf", vim.lsp.buf.format,         desc = "Format Code" },
  { "<leader>ca", vim.lsp.buf.code_action,    desc = "Code actions", mode = { "n", "v" } },
})
-- LSP auto-completion
-- TODO: Move auto-complete keymaps here

------------------
-- LSP diagnostics
------------------
-- Diagnostics level incrementer
local severity_levels = {
  [1] = "ERROR",
  [2] = "WARN",
  [3] = "INFO",
  [4] = "HINT",
}
local current_severity_min = 4 -- Start with most verbose: show all
local diagnostic_toggles = {
  signs = true,
  underline = true,
  virtual_text = false,
  virtual_lines = false,
}

-- toggle diagnostics level filterer
local function with_severity_filter(handler)
  return {
    show = function(ns, bufnr, diagnostics, opts)
      local filtered = vim.tbl_filter(function(d)
        return d.severity <= current_severity_min
      end, diagnostics)
      handler.show(ns, bufnr, filtered, opts)
    end,
    hide = function(ns, bufnr)
      handler.hide(ns, bufnr)
    end,
  }
end
-- Override the default diagnostics handlers
vim.diagnostic.handlers.signs = with_severity_filter(vim.diagnostic.handlers.signs)
vim.diagnostic.handlers.underline = with_severity_filter(vim.diagnostic.handlers.underline)
vim.diagnostic.handlers.virtual_text = with_severity_filter(vim.diagnostic.handlers.virtual_text)
vim.diagnostic.handlers.virtual_lines = with_severity_filter(vim.diagnostic.handlers.virtual_lines)

-- Template function to do toggling
local function make_diag_toggle(key, label)
  return function()
    diagnostic_toggles[key] = not diagnostic_toggles[key]
    vim.diagnostic.config({ [key] = diagnostic_toggles[key] })
    print(string.format("LSP %s %s", label, diagnostic_toggles[key] and "enabled" or "disabled"))
  end
end

-- helper function to move diagnostic level
local function increment_min_severity(incr)
  return function()
    new_level = current_severity_min + incr
    if new_level > 4 then
      print("!Already at maximum verbosity: " .. severity_levels[current_severity_min])
    elseif new_level < 1 then
      print("!Already at min verbosity: " .. severity_levels[current_severity_min])
    else
      current_severity_min = new_level
      vim.diagnostic.config({ severity = { min = current_severity_min } })
      print(
        "Min diagnostic severity set to: "
        .. current_severity_min
        .. ":"
        .. severity_levels[current_severity_min]
      )
    end
  end
end

whichKey.add({
  mode = "n",
  { "<leader>d",  group = "Diagnostics" },
  { -- toggle ALL diagnostic
    "<leader>dd",
    function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    desc = "Mask/Unmask all diagnostics",
    silent = true,
    noremap = true,
  },
  { "<leader>do", vim.diagnostic.open_float,                          desc = "Open diagnostic detail window" },
  { "<leader>dN", vim.diagnostic.goto_prev,                           desc = "Goto previous diagnostic warning" },
  { "<leader>dn", vim.diagnostic.goto_next,                           desc = "Goto next diagnostic warning" },
  { "<leader>ds", make_diag_toggle("signs", "signs"),                 desc = "Toggle diagnostic margin signs" },
  { "<leader>du", make_diag_toggle("underline", "underlines"),        desc = "Toggle diagnostic underlines" },
  { "<leader>du", make_diag_toggle("underline", "underlines"),        desc = "Toggle diagnostic underlines" },
  { "<leader>dt", make_diag_toggle("virtual_text", "virtual text"),   desc = "Toggle diagnostic virtual text" },
  { "<leader>dl", make_diag_toggle("virtual_lines", "virtual lines"), desc = "Toggle diagnostic virtual text" },
  { -- turn on all diagnostics
    "<leader>da",
    function()
      for k in pairs(diagnostic_toggles) do
        diagnostic_toggles[k] = true
      end
      vim.diagnostic.config(vim.deepcopy(diagnostic_toggles))
      print("All LSP diagnostics enabled")
    end,
    desc = "ALL diagnostics enabled",
  },
  { -- turn off all diagnostics
    "<leader>dq",
    function()
      for k in pairs(diagnostic_toggles) do
        diagnostic_toggles[k] = false
      end
      vim.diagnostic.config(vim.deepcopy(diagnostic_toggles))
      print("All diagnostics disabled")
    end,
    desc = "turn OFF all diagnostics",
  },
  { "<leader>dD", "<cmd>Telescope diagnostics<CR>", desc = "Find all diagnostics" },
  { "<leader>dk", increment_min_severity(1),        desc = "Increase min diagnostic severity" },
  { "<leader>dj", increment_min_severity(-1),       desc = "Decrease min diagnostic severity" },
})

-- TreeSitter (incremental_selection)
local inc_sel = require("nvim-treesitter.incremental_selection")
whichKey.add({
  mode = { "n", "v" },
  { "<leader>v",  group = "Incremental Selection" },
  { "<leader>vv", inc_sel.init_selection,         desc = "Init selection" },
  { "<leader>vn", inc_sel.node_incremental,       desc = "Increment node" },
  { "<leader>vc", inc_sel.scope_incremental,      desc = "Increment scope" },
  { "<leader>vN", inc_sel.node_decremental,       desc = "Decrement node" },
})

-- Code Folding (ufo)
whichKey.add({
  mode = { "n" },
  { "<leader>z",  group = "Incremental Selection" },
  {"zR", require("ufo").openAllFolds,  desc = "Open all folds" },
  {"zM", require("ufo").closeAllFolds,  desc = "Open all folds" },
  {"zh", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
-- Spell Checking
end,  desc = "Peek Fold" }
})

-- Spell Checking
whichKey.add({
  mode = { "n" },
  { "<leader>.", group = "Spell Checking" },
  {
    "<leader>..",
    function()
      -- toggle only the local window spelling
      vim.wo.spell = not vim.wo.spell
      print("Spell checking " .. (vim.wo.spell and "enabled" or "disabled"))
    end,
    desc = "Toggle spell checking",
  },
})

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
