return {
  "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
  config = function()
    require('toggle_lsp_diagnostics').init { underline = true, virtual_text = false , signs=true}
  end
}
