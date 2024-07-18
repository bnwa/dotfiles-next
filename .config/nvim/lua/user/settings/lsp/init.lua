local severity = vim.diagnostic.severity

local SIGNS = {
  [severity.ERROR] = '',
  [severity.WARN] = '',
  [severity.INFO] = '󰋽',
  [severity.HINT] = '',
}

return {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  diagnostic = {
    float = {
      border = 'rounded',
      source = 'always',
    },
    jump = {
      float = true,
    },
    severity_sort = true,
    signs = {
      text = SIGNS,
    },
    underline = false,
    update_in_insert = true,
    virtual_text = true,
  },
}
