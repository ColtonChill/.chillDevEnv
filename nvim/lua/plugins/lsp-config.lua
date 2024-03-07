return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "bashls", "clangd", "cmake", "pylsp", "jsonls"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig");
      -- These are needed for each language you want support for.
      lspconfig.lua_ls.setup({});
      lspconfig.pylsp.setup({});
      lspconfig.clangd.setup({});
      lspconfig.cmake.setup({});
    end
  }
}
