local opts = { noremap = true, silent = true }

local vo = vim.o
-- local vc = vim.cmd

local function merge(dest, origin)
  local merged = {}

  for k, v in pairs(dest) do
    merged[k] = v
  end

  for k, v in pairs(origin) do
    merged[k] = v
  end

  return merged
end

vo.fileencoding = "UTF-8"
vo.conceallevel = 0
vo.hlsearch = true
vo.cursorline = true         -- highlight the current line
vo.number = true             -- set numbered lines
vo.relativenumber = true     -- set relative numbered lines

vo.guifont = "monospace:h17" -- the font used in graphical neovim applications

vo.smartcase = true          -- smart case

vo.softtabstop = 2
vo.tabstop = 2
vo.shiftwidth = 2

-- vo.foldmethod = "expr"
-- vo.foldexpr = "nvim_treesitter#foldexpr()"
vo.foldcolumn = "1" -- '0' is not bad
vo.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vo.foldlevelstart = 99
vo.foldenable = true

vo.colorcolumn = "80,100,120"
vim.wo.wrap = false
vo.incsearch = true

-- vc[[hi ColorColumn ctermbg=darkgrey guibg=darkgrey]]

-- Shorten function name
-- local keymap = vim.api.nvim_set_keymap
local keymap = vim.keymap.set

local toggle_hl_search = function()
  local hlsearch = vim.api.nvim_get_vvar("hlsearch")
  if hlsearch == 1 then
    -- vim.api.nvim_set_vvar('hlsearch', 0)
    vim.cmd([[ :set nohlsearch ]])
  else
    -- vim.api.nvim_set_vvar('hlsearch', 1)
    vim.cmd([[ :set hlsearch ]])
  end
end

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

-- Add file rename action for typescript
local function rename_file()
  local source_file, target_file

  vim.ui.input({
      prompt = "Source: ",
      completion = "file",
      default = vim.api.nvim_buf_get_name(0)
    },
    function(input)
      source_file = input
    end
  )
  vim.ui.input({
      prompt = "Target: ",
      completion = "file",
      default = source_file
    },
    function(input)
      target_file = input
    end
  )

  local params = {
    command = "_typescript.applyRenameFile",
    arguments = {
      {
        sourceUri = source_file,
        targetUri = target_file,
      },
    },
    title = ""
  }

  vim.lsp.util.rename(source_file, target_file)
  vim.lsp.buf.execute_command(params)
end

require("lspconfig").ts_ls.setup {
  commands = {
    RenameFile = {
      rename_file,
      description = "Rename File"
    },
  }
}

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- Toggle hlsearch
keymap("n", "<leader>sl", toggle_hl_search, merge(opts, { desc = "Toggle hlsearch" }))

-- Display file tree sidebar
keymap("n", "<leader>y", ":NvimTreeToggle<cr>", merge(opts, { desc = "Toggle Nvim Tree" }))
keymap("n", "<leader>t", ":NvimTreeFocus<cr>", merge(opts, { desc = "Focus Nvim Tree" }))
keymap("n", "<leader>ff", ":NvimTreeFindFile<cr>", merge(opts, { desc = "Show current file in Nvim Tree" }))
keymap(
  "n",
  "<leader>fs",
  ":NvimTreeFindFile<cr><C-w><C-p>",
  merge(opts, { desc = "Show current file Nvim Tree and continue editing" })
)

-- Search
keymap("n", "<leader>sc", require("telescope.builtin").resume, { desc = "[S]earch [C]ontinue" })
keymap('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })

-- Switch between windows
keymap("n", "<leader>h", "<C-w>h", merge(opts, { desc = "Switch to window on the left" }))
keymap("n", "<leader>j", "<C-w>j", merge(opts, { desc = "Switch to window below" }))
keymap("n", "<leader>k", "<C-w>k", merge(opts, { desc = "Switch to window above" }))
keymap("n", "<leader>l", "<C-w>l", merge(opts, { desc = "Switch to window on the right" }))

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", merge(opts, { desc = "Increase window size vertically" }))
keymap("n", "<C-Down>", ":resize -2<CR>", merge(opts, { desc = "Decrease window size vertically" }))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", merge(opts, { desc = "Decrease window size horizontally" }))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", merge(opts, { desc = "Increase window size horizontally" }))

-- Switch buffers
keymap("n", "<left>", ":bp<CR>", merge(opts, { desc = "Switch to previous buffer" }))
keymap("n", "<right>", ":bn<CR>", merge(opts, { desc = "Switch to next buffer" }))

-- Move line up or down
keymap("n", "<up>", ":m .-2<CR>", merge(opts, { desc = "Move line up" }))
keymap("n", "<down>", ":m .+1<CR>", merge(opts, { desc = "Move line down" }))

-- Toggle autosave
keymap("n", "<leader>na", ":ASToggle<CR>", merge(opts, { desc = "Toggle file autosaving" }))

-- Change line numbers format
keymap("n", "<leader>nr", ":setlocal number relativenumber<CR>", merge(opts, { desc = "Set line numbers to relative" }))
keymap("n", "<leader>nn", ":setlocal number norelativenumber<CR>",
  merge(opts, { desc = "Set line numbers to not relative" }))
keymap("n", "<leader>nt", function()
  local rn = vim.bo.relativenumber or vim.o.relativenumber
  if rn then
    vim.bo.relativenumber = false
  else
    vim.bo.relativenumber = true
  end
end, merge(opts, { desc = "Toggle line numbers" }))

-- Format code
--keymap("n", "<leader>cf", vim.lsp.buf.format, merge(opts, { desc = "[C]ode [F]ormat" }))
keymap("n", "<Leader>cf", function()
  vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "[lsp] format" })

-- Folding
keymap("n", "zR", require("ufo").openAllFolds, merge(opts, { desc = "Open all folds" }))
keymap("n", "zM", require("ufo").closeAllFolds, merge(opts, { desc = "Close all folds" }))

-- Close buffers
keymap("n", "<leader>cx", ":%bd<CR>", merge(opts, { desc = "Close all buffers" }))
keymap("n", "<leader>ce", ":%bd|e#<CR>", merge(opts, { desc = "[C]lose all buffers [e]xcept current one" }))
keymap("n", "<leader>cb", ":bd<CR>", merge(opts, { desc = "[C]lose current [B]uffer" }))

-- Wordwrap
keymap("n", "<leader>ww", ":set wrap|:set linebreak<CR>", merge(opts, { desc = "[W]ord [W]rap" }))

-- Rename file
keymap("n", "<leader>rf", ":RenameFile<CR>", merge(opts, { desc = "[R]ename [F]ile for typescript" }))

-- Trouble plugin
keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", merge(opts, { desc = "Display Trouble Window" }))
keymap(
  "n",
  "<leader>xw",
  "<cmd>TroubleToggle workspace_diagnostics<cr>",
  merge(opts, { desc = "Trouble: Display [w]orkspace diagnostics" })
)
keymap(
  "n",
  "<leader>xd",
  "<cmd>TroubleToggle document_diagnostics<cr>",
  merge(opts, { desc = "Trouble: Display [d]ocument diagnostics" })
)
keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", merge(opts, { desc = "Trouble: Display [l]oclist" }))
keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", merge(opts, { desc = "Trouble: Display [q]uickfix" }))
keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", merge(opts, { desc = "Trouble-LSP: [g]oto [r]eferences" }))

-- Insert --
-- Press jk fast to enter normal mode
keymap("i", "jk", "<ESC>", merge(opts, { desc = "Exit insert mode and switch to normal mode" }))
-- Move line up or down
-- keymap("i", "<up>", "<ESC>:m .-2<CR>==gi", merge(opts, { desc = "Move line up" }))
-- keymap("i", "<down>", "<ESC>:m .+1<CR>==gi", merge(opts, { desc = "Decrease window size vertically" }))
-- save file
keymap("i", "<C-s>", "<ESC>:w<CR>==gi", merge(opts, { desc = "Decrease window size vertically" }))

-- Visual --
-- Move line up or down
-- keymap("v", "<up>", "<ESC>:m '<-2<CR>gv=gv", merge(opts, { desc = "Decrease window size vertically" }))
-- keymap("v", "<down>", "<ESC>:m '>+2<CR>gv=gv", opts)

vim.api.nvim_create_autocmd("BufLeave", {
  pattern = {
    "*.c",
    "*.h",
    "*.ts",
    "*.json",
    "*.js",
    "*.yaml",
    "*.html",
    "*.htmx",
    "*.phtml",
    "*.php",
    "*.java",
    "*.go",
    "*.v",
    "*.sh",
    "Makefile",
    "*.lua",
    "*.conf",
  },
  command = "%s/\\s\\+$//e",
})

-- vim.api.nvim_create_autocmd(
-- 	"BufReadPost,FileReadPost", {
-- 		pattern = { "*" },
-- 		command = "normal zR",
-- 	}
-- )
vim.cmd([[au BufNewFile,BufRead *.htmx set filetype=html]])
vim.cmd([[au BufNewFile,BufRead *.phtml set filetype=php]])
-- vim.cmd([[au BufNewFile,BufRead *.v set filetype=vlang]])
vim.cmd([[ autocmd FileType php set iskeyword+=$ ]])

-- vim: ts=2 sts=2 sw=2 et
