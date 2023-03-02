local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }
--
-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Display file tree sidebar
keymap("n", "<leader>y", ":NvimTreeToggle<cr>", opts)
keymap("n", "<leader>t", ":NvimTreeFocus<cr>", opts)

-- Switch between windows
keymap("n", "<leader>h", "<C-w>h", opts)
keymap("n", "<leader>j", "<C-w>j", opts)
keymap("n", "<leader>k", "<C-w>k", opts)
keymap("n", "<leader>l", "<C-w>l", opts)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move line up or down
keymap("n", "<left>", ":bp<CR>", opts)
keymap("n", "<right>", ":bn<CR>", opts)

-- Switch buffers
keymap("n", "<up>", ":m .-2<CR>", opts)
keymap("n", "<down>", ":m .+1<CR>", opts)

-- Insert --
-- Press jk fast to enter normal mode
keymap("i", "jk", "<ESC>", opts)
-- Move line up or down
keymap("i", "<up>", "<ESC>:m .-2<CR>==gi", opts)
keymap("i", "<down>", "<ESC>:m .+1<CR>==gi", opts)
-- save file
keymap("i", "<C-s>", "<ESC>:w<CR>==gi", opts)

-- Visual --
-- Move line up or down
keymap("v", "<up>", "<ESC>:m '<-2<CR>gv=gv", opts)
keymap("v", "<down>", "<ESC>:m '>+2<CR>gv=gv", opts)

vim.opt.fileencoding = 'utf-8'
vim.opt.cmdheight = 2
vim.opt.conceallevel = 0
vim.opt.hlsearch = true
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.relativenumber = true                   -- set relative numbered lines

vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications

vim.opt.smartcase = true                        -- smart case

-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

vim.api.nvim_create_autocmd(
	"BufWritePre", {
--	FileType c,cpp,java,php autocmd BufWritePre <buffer>
	pattern = {
		"*.c", "*.h",
		"*.ts", "*.json", "*.js", "*.yaml",
		"*.php", "*.java",
		"Makefile",
		"*.lua",
	},
	command = '%s/\\s\\+$//e'
})
