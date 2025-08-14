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

function M.on_attach(server_on_attach)
  return function(client, buf)
    if type(server_on_attach) ~= 'function' or server_on_attach(client, buf) then
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
    end
  end
end

function M.get_clients(buf)
  return vim.lsp.get_clients { bufnr = buf }
end

return M
