return {
    "jose-elias-alvarez/null-ls.nvim",
    config = function ()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.diagnostics.tsc,
            },
        })
    end,
    requires = { "nvim-lua/plenary.nvim" },
}
