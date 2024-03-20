-- ------------------------------------------------------------------------------
-- Add keymaps to surround text with: ", ', ), >, }, >
-- ------------------------------------------------------------------------------
return {
  "kylechui/nvim-surround",

  version = "*", -- Use for stability; omit to use `main` branch for the latest features

  event = "VeryLazy",

  opts = {},

  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
}

-- vim: ts=2 sts=2 sw=2 et
