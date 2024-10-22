return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

        -- Install parsers synchronously (only applied to `ensure_installed`) --
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          enable = true,
          custom_captures = {
            ["declarator"] = "Spell",
            ["identifier"] = "Spell",
            --["namespace_identifier"] = "Normal",
            --["field_expression"] = "Normal",
          },
        },

        incremental_selection = {
          enable = true,
        },

        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = true,
          },

          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          -- move = {},
        },
      })
     
 --     vim.treesitter.query.set("cpp", "highlights", [[
 --       ;; extends
 --       ;; inherits: cpp
 --       (init_declarator
 --         declarator: (identifier) @spell
 --       )
 --     ]])
    end,
  },
  ------------------------------------------------
  -- This is a plugin that extends treesitter
  -- Allows for making definition and motions to
  -- augment selection, swaping, moving, etc
  -- (https://www.youtube.com/watch?v=ff0GYrK3nT0)
  ------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
