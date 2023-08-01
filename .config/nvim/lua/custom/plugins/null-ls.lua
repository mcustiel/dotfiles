return {
    "jose-elias-alvarez/null-ls.nvim",

    config = function()
        local null_ls = require("null-ls")
        local phpactor = require("phpactor")

        if phpactor then
            null_ls.register({
                method = null_ls.methods.CODE_ACTION,
                filetypes = {"php"},
                generator = {
                    fn = function()
                        vim.cmd([[ PhpActor transform ]])
                    end
                }
            })
        end

        null_ls.setup({
            sources = {
                null_ls.builtins.diagnostics.eslint,
                null_ls.builtins.formatting.eslint,
                null_ls.builtins.diagnostics.tsc,
                null_ls.builtins.formatting.gofmt,
            },
        })
    end,

    dependencies = {
        "nvim-lua/plenary.nvim",
        "bprod/phpactor.nvim",
    },
}
