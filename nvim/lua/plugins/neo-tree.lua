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
      source_selector = {
        winbar = true; -- upper system, buffer, git windows
        statusline = true;  -- lower version 
      }
    })
  end
}
