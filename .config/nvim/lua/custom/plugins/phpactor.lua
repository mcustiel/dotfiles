return {
	"gbprod/phpactor.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim", -- required to update phpactor
		"neovim/nvim-lspconfig", -- required to automaticly register lsp server
		"jose-elias-alvarez/null-ls.nvim",
	},

	config = function()
		require("phpactor").setup({
			install = {
				bin = "/home/mcustiel/Development/scripts/phpactor",
			}
		})
		local null_ls = require("null-ls")
		null_ls.register({
			method = null_ls.methods.CODE_ACTION,
			filetypes = { "php" },
			generator = {
				fn = function()
					vim.cmd([[ PhpActor transform ]])
				end
			}
		})
	end,
}
