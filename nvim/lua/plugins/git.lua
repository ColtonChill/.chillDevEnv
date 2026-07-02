return {
	{
		"sindrets/diffview.nvim",
		config = function()
			require("diffview").setup({
			--	keymaps = {
			--		disable_defaults = false, -- Disable the default keymaps
			--	},
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		-- cmd = "Neogit",
		config = function()
			require("neogit").setup()
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
}
