-- ------------------------------------------------------------------------------
-- Closes opened buffers after some inactivity time
-- ------------------------------------------------------------------------------
return {
	"chrisgrieser/nvim-early-retirement",

	config = function()
		require("early-retirement").setup({ retirementAgeMins = 5 })
	end,

	event = "VeryLazy",
}

-- vim: ts=2 sts=2 sw=2 et
