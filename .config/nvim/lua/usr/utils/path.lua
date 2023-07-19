local api = vim.api
local fn = vim.fn
local fs = vim.fs
local M = {}


function M.find_project_root(root_files, bufname)
  bufname = bufname or api.nvim_buf_get_name(api.nvim_get_current_buf())
  fs.dirname(fs.find(root_files, {
    path = fs.dirname(bufname),
    stop = vim.loop.os_homedir(),
    upward = true,
  })[1])
end

function M.is_readable(path)
  return 1 == fn.filereadable(path)
end

function M.is_directory(path)
  return 1 == fn.isdirectory(path)
end


return M
