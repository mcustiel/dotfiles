return {
	"bprod/phpactor.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim", -- required to update phpactor
		"neovim/nvim-lspconfig" -- required to automaticly register lsp serveur
	},

	config = function()
		require("phpactor").setup({
			install = {
				bin = "/home/mcustiel/Development/scripts/phpactor",
			}
		})
	end,
}

