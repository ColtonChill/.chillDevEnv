return {
  -----------------
  -- Modern Fold --
  -----------------
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local language_servers = require("lspconfig").util.available_servers()
    for _, ls in ipairs(language_servers) do
      require("lspconfig")[ls].setup({
        capabilities = capabilities,
      })
    end
    require("ufo").setup()
--todo: Consider adding a method=indent feature if the LSP craps out (see option 3 in example github)
  end,
}
