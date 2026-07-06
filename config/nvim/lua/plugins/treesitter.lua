return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "python", "c++" },
    auto_install = true,
    highlight = { enable = true },
  },
}
