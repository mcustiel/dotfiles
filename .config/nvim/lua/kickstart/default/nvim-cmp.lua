return { -- Autocompletion
	'hrsh7th/nvim-cmp',

	event = 'InsertEnter',

	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			'L3MON4D3/LuaSnip',
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This step is not supported in many windows environments
				-- Remove the below condition to re-enable on windows
				if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
					return
				end
				return 'make install_jsregexp'
			end)(),
		},
		'saadparwaiz1/cmp_luasnip',

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',

		-- If you want to add a bunch of pre-configured snippets,
		--    you can use this plugin to help you. It even has snippets
		--    for various frameworks/libraries/etc. but you will have to
		--    set up the ones that are useful for you.
		-- 'rafamadriz/friendly-snippets',
	},

	config = function()
		-- See `:help cmp`
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
				  luasnip.lsp_expand(args.body)
				end,
			  },
			  completion = {
				completeopt = 'menu,menuone,noinsert',
			  },
			  mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
				  behavior = cmp.ConfirmBehavior.Replace,
				  select = true,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
				  if cmp.visible() then
					cmp.select_next_item()
				  elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				  else
					fallback()
				  end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
				  if cmp.visible() then
					cmp.select_prev_item()
				  elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				  else
					fallback()
				  end
				end, { 'i', 's' }),
			  },
			  sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
			  },
		}
	end,
}

-- vim: ts=2 sts=2 sw=2 et
