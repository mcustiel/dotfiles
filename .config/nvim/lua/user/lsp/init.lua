require("nvim-lsp-installer").setup {
    log_level = vim.log.levels.DEBUG,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    },
    
}
require 'user.lsp.ts'
require 'user.lsp.keymaps'
