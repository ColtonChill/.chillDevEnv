return {
	"folke/which-key.nvim",
	dependencies = { "echasnovski/mini.nvim", version = false },
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		--presets = {
		--  bottom_search = true,
		--  command_palette = true,
		--  long_message_to_split = true,
		--  inc_rename = true,
		--},
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
}
