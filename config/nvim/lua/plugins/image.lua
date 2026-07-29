return {
  -- "3rd/image.nvim",
  -- opts = {
  --   backend = "ueberzug",
  --   build = false,
  --   processor = "magick_cli",
  -- }
  -- lua/plugins/image.lua
  -- {
  "3rd/image.nvim",
  build = false, -- prevents lazy from trying to build the magick rock
  opts = {
    backend = "kitty",
    processor = "magick_cli", -- no compilation, just needs `imagemagick` installed
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        floating_windows = false,
        filetypes = { "markdown", "vimwiki" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    -- max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = true,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
