return {
  has_client = function(buf)
    local attached = vim.lsp.get_clients({ bufnr = buf })
    return #attached > 0
  end,
}
