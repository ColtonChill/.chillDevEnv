return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			source_selector = {
				winbar = true, -- upper system, buffer, git windows
				statusline = true, -- lower version
			},
		})
	end,
}
