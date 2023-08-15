return {
	'navarasu/onedark.nvim',

	-- Theme inspired by Atom
	priority = 1000,

	config = function()
		vim.cmd.colorscheme 'onedark'
	end,
}
