return {
	{
		--------------------------------------------------
		-- MASON, the LSP, DAP, Linter, & Formater manager
		--------------------------------------------------
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
					"intelephense",
				},
			})
		end,
	},
	{ -- Just a pile of configs
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			-- auto completeions
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local opts = { capabilities = capabilities }
			-- These are needed for each language you want support for.
			lspconfig.lua_ls.setup(opts)
			lspconfig.bashls.setup(opts)
			lspconfig.pylsp.setup(opts)
			lspconfig.jsonls.setup(opts)
			lspconfig.clangd.setup(opts)
			lspconfig.cmake.setup(opts)
			lspconfig.intelephense.setup(opts)
		end,
	},
	--------------------------------
	-- DAP Stuff -- WORK IN PROGRESS
	--------------------------------
	{ "mfussenegger/nvim-dap" },
	-----------------------------
	-- Linter & Formater Stuff --
	-----------------------------
	{ -- Fork of null-ls (wraps cli tools in a LSP interface for nvim)
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = { -- Anything not supported by mason.
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.clang_format,
					require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
				},
			})
		end,
	},

	--   { -- Helps none-ls talk to mason
	--     "jay-babu/mason-null-ls.nvim",
	--     event = { "BufReadPre", "BufNewFile" },
	--     dependencies = {
	--       "williamboman/mason.nvim",
	--       "nvimtools/none-ls.nvim",
	--     },
	--     config = function()
	--       require("mason-null-ls").setup({
	--         ensure_installed = { -- Anything supported by mason.
	--           "stylua",
	--           "prettierd",
	--           "clang_format",
	--         },
	--         automatic_installation = true,
	--       })
	--
	--       local null_ls = require("null-ls")
	--       require("null-ls").setup({
	--         null_ls.setup({
	--           sources = { -- Anything not supported by mason.
	--             null_ls.builtins.formatting.stylua,
	--             null_ls.builtins.formatting.prettierd,
	--             null_ls.builtins.formatting.clang_format,
	--             -- null_ls.builtins.completion.spell,
	--             -- require("none-ls.diagnostics.cpplint"),
	--           },
	--         }),
	--         -- null_ls.register(require("none-ls-shellcheck.diagnostics"))
	--         -- null_ls.register(require("none-ls-shellcheck.code_actions"))
	--       })
	--     end,
	--   },
	--  {
	--    "stevearc/conform.nvim",
	--    config = function()
	--      require("conform").setup({
	--        formatters_by_ft = {
	--          lua = { "stylua" },
	--          -- Conform will run multiple formatters sequentially
	--          python = { "isort", "black" },
	--          -- You can customize some of the format options for the filetype (:help conform.format)
	--          rust = { "rustfmt", lsp_format = "fallback" },
	--          -- Conform will run the first available formatter
	--          javascript = { "prettierd", "prettier", stop_after_first = true },
	--        },
	--      })
	--    end,
	--  },
}
