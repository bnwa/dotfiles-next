local AUGROUP = vim.api.nvim_create_augroup("LazyUser", { clear = true })

local M = {}

--- @param evts string[]
--- @param filter string[]
--- @param desc string
--- @param listener function
function M.event(evts, filter, desc, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = AUGROUP,
    pattern = filter,
  })
end

--- @param evts string[]
--- @param filter string[]
--- @param desc string
--- @param listener function
function M.once(evts, filter, desc, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = AUGROUP,
    once = true,
    pattern = filter,
  })
end

--- @param evts string[]
--- @param buf number
--- @param desc string
--- @param listener function
function M.buffer(evts, buf, desc, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = AUGROUP,
    buffer = buf,
  })
end

--- @param filetypes string[]
--- @param listener function
function M.filetype(filetypes, listener)
  vim.api.nvim_create_autocmd("FileType", {
    callback = listener,
    group = AUGROUP,
    pattern = filetypes,
  })
end

--- @param evt string
--- @param data? any
function M.dispatch(evt, data)
  vim.api.nvim_exec_autocmds(evt, {
    group = AUGROUP,
    data = data or nil,
  })
end

return M
