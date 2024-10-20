local function has_client(buf)
    local attached = vim.lsp.get_clients({ bufnr = buf })
    return #attached > 0
end
