-- ------------------------------------------------------------------------------
-- Displays function signature while typing
-- ------------------------------------------------------------------------------
return {
	"ray-x/lsp_signature.nvim",

	config = function()
		require("lsp_signature").setup({
			bind = true, -- This is mandatory, otherwise border config won't get registered.
			handler_opts = {
				border = "rounded",
			},
		})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
