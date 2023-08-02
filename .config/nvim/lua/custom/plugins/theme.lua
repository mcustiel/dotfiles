return {
    "NLKNguyen/papercolor-theme",

    config = function()
        local colorscheme = "PaperColor"

        local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
        if not status_ok then
            vim.notify("colorscheme " .. colorscheme .. " not found!")
            return
        end
    end,
}
