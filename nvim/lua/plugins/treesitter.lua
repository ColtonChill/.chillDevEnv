return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    --ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "python", "javascript", "html" };
    ensure_installed = { "cpp", "lua", "vim" }
    auto_install = true
    --sync_install = false,
    highlight = { enable = true }
    indent = { enable = true }
  end,
}
