-- ------------------------------------------------------------------------------
-- Displays nice notify popups
-- ------------------------------------------------------------------------------
return {
	"rcarriga/nvim-notify",

	config = function()
		local notify = require("notify")

		notify.setup({
			render = "compact",
			timeout = 3000,
		})
		vim.notify = function(message, level, opts)
			return notify(message, level, opts)
		end
	end,
}

-- vim: ts=2 sts=2 sw=2 et
