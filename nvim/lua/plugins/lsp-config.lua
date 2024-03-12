return {
  { --LSP, DAP, Linter, & Formater manager
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  ---------------
  -- LSP Stuff --
  ---------------
  { -- LSP interface between mason and lspconfig
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "pylsp",
          "jsonls",
          "clangd",
          "cmake",
        },
      })
    end,
  },
  { -- Just a pile of configs
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- These are needed for each language you want support for.
      lspconfig.lua_ls.setup({})
      lspconfig.pylsp.setup({})
      lspconfig.clangd.setup({})
      lspconfig.cmake.setup({});
    end,
  },
  --------------------------------
  -- DAP Stuff -- WORK IN PROGRESS
  --------------------------------
  {},
  -----------------------------
  -- Linter & Formater Stuff --
  -----------------------------
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
        sources = {
          -- null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.formatting.clang_format,
          -- null_ls.builtins.completion.spell,
          -- require("none-ls.diagnostics.cpplint"),
        },
      })
      -- null_ls.register(require("none-ls-shellcheck.diagnostics"))
      -- null_ls.register(require("none-ls-shellcheck.code_actions"))
    end,
  },
}
