local lsp = vim.lsp
local api = vim.api
local fs = vim.fs
local bo = vim.bo
local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

bo.shiftwidth = 2
bo.softtabstop = 2
bo.tabstop = 2

if not ok then return end

local root_dir = fs.find('nvim', {
  path = fs.dirname(api.nvim_buf_get_name(0)),
  stop = vim.loop.os_homedir(),
  type = 'directory',
  upward = true,
})[1]

-- TODO When not working w/ nvim config, should add predicates
local libraries = vim.api.nvim_get_runtime_file("", true)

local capabilities = vim.tbl_deep_extend('force',
lsp.protocol.make_client_capabilities(),
cmp_lsp.default_capabilities())

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
  before_init = require('neodev.lsp').before_init,
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  name = 'lua-language-server',
  root_dir = root_dir,
  settings = settings,
})
