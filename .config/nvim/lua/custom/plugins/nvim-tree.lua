-- ------------------------------------------------------------------------------
-- Files tree
-- ------------------------------------------------------------------------------
return {
  "nvim-tree/nvim-tree.lua",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },

  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
        highlight_opened_files = "all",
      },
      filters = {
        dotfiles = false,
        custom = { "\\.git$", "^node_modules$", "^dist$", "^.eslintcache$" },
      },
      git = {
        ignore = false,
      },
      view = {
        width = 36,
      },
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
