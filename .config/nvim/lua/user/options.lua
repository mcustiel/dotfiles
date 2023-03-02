local options = { backspace = "indent,eol,start",

    wildmenu = true,

    smarttab = true,
    expandtab = true,
    tabstop = 4,
    softtabstop=4,
    shiftwidth=4,
    autoindent=true,

    -- undofile = true,                         -- enable persistent undo
    -- updatetime = 300,                        -- faster completion (4000ms default)
    -- clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 2,                           -- more space in the neovim command line for displaying messages
    -- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file

    -- encoding = "utf-8"

    -- hlsearch = true,                         -- highlight all matches on previous search pattern
    -- ignorecase = true,                       -- ignore case in search patterns
    -- mouse = "a",                             -- allow the mouse to be used in neovim
    -- mouse="",                                   -- Make it work in ITerm2
    pumheight = 10,                          -- pop up menu height

    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = true,                   -- set relative numbered lines

    guifont = "monospace:h17",               -- the font used in graphical neovim applications

    smartcase = true,                        -- smart case
    background = dark
}

vim.cmd [[set path+=**]]
vim.cmd [[
  syntax enable
  " colorscheme onedark
  :hi CursorLine   cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkgray guifg=white
  :hi CursorColumn cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkgray guifg=white
  :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
]]

for k, v in pairs(options) do
  vim.opt[k] = v
end
