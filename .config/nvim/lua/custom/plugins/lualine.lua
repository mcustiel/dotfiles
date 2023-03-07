local function parentFolder()
    local cwd = vim.fn.getcwd()
    local currentPart = ""
    for item in string.gmatch(cwd, "[^/]+") do
      currentPart = item;
    end
    return currentPart
end

return {
    'nvim-lualine/lualine.nvim',
    config = function ()
        local lualine = require("lualine")
        lualine.setup {
          options = {
            icons_enabled = true,
            theme = 'material',
          },
          sections = {
            lualine_a = {parentFolder, 'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
        }
    end
}
