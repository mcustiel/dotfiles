return { -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',

	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},

	build = ':TSUpdate',

	config = function()
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			ensure_installed = {
				'c', -- 'go', 'v', 'zig',
				 -- 'python', 'rust',
				'tsx', 'javascript', 'typescript',
				'java', -- 'php',
				'lua', 'vimdoc', 'vim',
				'bash', 'regex',
				'json', 'yaml', 'html',
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			-- List of parsers to ignore installing
			ignore_install = {},
			-- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
			modules = {},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
					},
					goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
					},
					goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
					},
					goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
					['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
					['<leader>A'] = '@parameter.inner',
					},
				},
			}

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}

-- vim: ts=2 sts=2 sw=2 et
