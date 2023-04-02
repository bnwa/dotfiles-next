local lsp = vim.lsp
local bo = vim.bo
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

bo.shiftwidth = 2
bo.softtabstop = 2
bo.tabstop = 2

if not ok then return end

-- TODO When not working w/ nvim config, should add predicates
local libraries = vim.api.nvim_get_runtime_file("", true)

local settings = {
  Lua = {
    completion ={
      autoRequire = true,
      callSnippet = "Replace",
      enable = true,
      keywordSnippet = "Replace",
    },
    diagnostics = {
      globals = { "vim" },
    },
    hint = {
      enable = true,
      setType = true,
    },
    runtime = {
      path = {
        '?.lua',
        '?/init.lua',
      },
      version = "LuaJIT",
    },
    telemetry = {
      enable = false,
    },
    workspace = {
      library = libraries,
    },
  }
}

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  pattern = '*.lua',
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local server = client.server_capabilities

    -- N.B. workaround formatexpr getting set to vim default
    if server.documentRangeFormattingProvider then
      bo[buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end

    vim.diagnostic.config {
      virtual_text = false,
    }
  end
})

vim.lsp.start({
  capabilities = vim.tbl_deep_extend('force',
    lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()),
  cmd = { 'lua-language-server' },
  name = "lua_ls",
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = settings })
  end,
  root_dir = vim.fs.dirname(vim.fs.find(
    { 'init.lua' },
    { upward = true, stop = vim.env.HOME })[1]),
  settings = settings,
})
