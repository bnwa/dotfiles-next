local M = {}
local augroup = vim.api.nvim_create_augroup('Config', { clear = true })

function M.on(match, events, listener)
  vim.api.nvim_create_autocmd(events, {
    callback = listener,
    group = augroup,
    pattern = match,
  })
end

return M
