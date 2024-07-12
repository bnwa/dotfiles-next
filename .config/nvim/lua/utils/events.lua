local api = vim.api
local augroup = api.nvim_create_augroup("UserConfig", { clear = true })

local M = {}

M.AUGROUP = augroup

function M.on(match, events, listener)
  api.nvim_create_autocmd(events, {
    callback = listener,
    group = augroup,
    pattern = match,
  })
end

return M
