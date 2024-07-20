local USER_AUGROUP = vim.api.nvim_create_augroup('UserConfig', { clear = true })

local M = {}

function M.event(desc, evts, filter, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = USER_AUGROUP,
    pattern = filter,
  })
end

function M.once(desc, matches, evts, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = USER_AUGROUP,
    once = true,
    pattern = matches,
  })
end

function M.buffer(desc, buf, evts, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = USER_AUGROUP,
    buffer = buf,
  })
end

function M.filetype(matches, listener)
  vim.api.nvim_create_autocmd('FileType', {
    callback = listener,
    group = USER_AUGROUP,
    pattern = matches,
  })
end

return M
