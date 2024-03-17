local bo = vim.bo
local fs = vim.fs
local api = vim.api
local lsp = vim.lsp
local cmp_ok, cmp = pcall(require, 'cmp_nvim_lsp')
local snip_ok, _ = pcall(require, 'luasnip')
local schemas_ok, schemas = pcall(require, 'schemastore')

bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2

if not cmp_ok then return end
if not snip_ok then return end
if not schemas_ok then return end

local root_dir = fs.find('.git', {
  path = fs.dirname(api.nvim_buf_get_name(0)),
  stop = vim.loop.os_homedir(),
  type = 'directory',
  upward = true,
})[1]

local capabilities = vim.tbl_deep_extend('force',
    lsp.protocol.make_client_capabilities(),
    cmp.default_capabilities(),
    { textDocument = { completion = { completionItem = { snippetSupport = true } } } })

local settings = {
  json = {
    allowComments = true,
    schemas = schemas.json.schemas(),
    validate = { enabled = true },
  }
}

vim.lsp.start({
  capabilities = capabilities,
  cmd = { 'vscode-json-language-server', '--stdio' },
  name = 'json-lsp',
  on_attach = function(client, bufnr)
    -- N.B. workaround formatexpr getting set to vim default
    if client.server_capabilities.documentRangeFormattingProvider then
      bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end
  end,
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = settings })
  end,
  root_dir = root_dir,
  settings = settings,
})

