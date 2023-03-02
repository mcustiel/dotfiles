local req_status_ok, lspconfig = pcall(require, "lspconfig")
if not req_status_ok then
  return
end

local req_status_ok, util = pcall(require, "lspconfig/util")
if not req_status_ok then
  return
end

local req_status_ok, keymap = pcall(require, "user.lsp.keymap_onattach")
if not req_status_ok then
  return
end

local server_name = "tsserver"
local bin_name = "typescript-language-server"

-- local installer = util.npm_installer {
--  server_name = server_name;
--  packages = { "typescript-language-server" };
--  binaries = {bin_name};
-- }

require 'lspconfig'.tsserver.setup {
    on_attach = keymap.on_attach,
    -- flags = lsp_flags.flags
}

