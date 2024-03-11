-- ------------------------------------------------------------------------------
-- Provides improved folding functionality
-- ------------------------------------------------------------------------------
return {
	"kevinhwang91/nvim-ufo",

	dependencies = { "kevinhwang91/promise-async" },

	config = function()
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities.textDocument.foldingRange = {
		--   dynamicRegistration = false,
		--   lineFoldingOnly = true
		-- }
		-- local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
		-- for _, ls in ipairs(language_servers) do
		--   if ls ~= "yamlls" then
		--     require('lspconfig')[ls].setup({
		--       capabilities = capabilities
		--       -- you can add other fields for setting up lsp server in this table
		--     })
		--   end
		-- end
		require("ufo").setup({
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		})
	end,
}
