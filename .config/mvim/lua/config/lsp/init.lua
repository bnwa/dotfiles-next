local M = {}

M.diagnostics = {
  float = {
    source = 'if_many',
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '󰋽',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  underline = false,
  update_in_insert = true,
  virtual_text = false
}

function M.match(file_ext)
  if file_ext == 'lua' then
    return { 'lua_ls' }
  end
  return nil
end

function M.get_clients(buf)
  return vim.lsp.get_clients { bufnr = buf }
end

function M.on_attach(server_on_attach)
  return function(client, buf)
    local supports_inlay_hints =
    client.supports_method('textDocument/inlayHint', { bufnr = buf })
    and vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buftype == ''

    local supports_code_lens =
    client.supports_method('textDocument/codeLens', { bufnr = buf })
    and vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buftype == ''

    if supports_code_lens then
      vim.lsp.codelens.refresh()
      -- TODO bind autocmd to config-global constant so that
      -- `server_on_attach` can optionally disable/override later
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buf,
        callback = vim.lsp.codelens.refresh,
      })
    end

    if supports_inlay_hints then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end

    vim.diagnostic.config(M.diagnostics)
    vim.diagnostic.enable(true, { bufnr = buf })

    if type(server_on_attach) == 'function' then
      server_on_attach(client, buf)
    end
  end
end

---@param servers table<string,vim.lsp.Config>
function M.config(servers)
  local cmp = require 'blink.cmp'
  for server_name, server_config in pairs(servers) do
    local server_on_attach = server_config.on_attach
    local server_capabilities = server_config.capabilities or {}

    local config = vim.tbl_extend('force',
      server_config,
      { capabilities = nil, on_attach = nil },
      { capabilities = cmp.get_lsp_capabilities(server_capabilities, true) },
      { on_attach = M.on_attach(server_on_attach) })

    vim.lsp.config(server_name, config)
  end
end

return M
