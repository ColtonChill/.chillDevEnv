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

	{ -- LSP interface between mason and lspconfig
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"bashls",
					"pylsp",
					"jsonls", -- "clangd", "cmake",
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
			-- lspconfig.clangd.setup({});
			-- lspconfig.cmake.setup({});
		end,
	},
}
