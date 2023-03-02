local req_status_ok, lspconfig = pcall(require, "lspconfig")
if not req_status_ok then
  return
end

local req_status_ok, util = pcall(require, "lspconfig/util")
if not req_status_ok then
  return
end

local req_status_ok, keymap = pcall(require, "user.lsp.keymap")
if not req_status_ok then
  return
end

lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
    on_attach = keymap.on_attach,
}

function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
end

vim.cmd [[
    autocmd BufWritePre *.go lua go_org_imports()
]]
