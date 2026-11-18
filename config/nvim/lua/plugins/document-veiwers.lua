--
-- follow this guide to building magicks from source (dependency)
-- https://linuxcapable.com/how-to-install-imagemagick-on-ubuntu-linux/
--
return {
  {
    "r-pletnev/pdfreader.nvim",
    lazy         = false,
    dependencies = {
      "folke/snacks.nvim",           -- image rendering
      "nvim-telescope/telescope.nvim", -- pickers
    },
    config       = function()
      require("pdfreader").setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}
