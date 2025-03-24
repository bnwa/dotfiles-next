local fn = vim.fn

local M = {}

function M.can_read_file(path)
  return 1 == fn.filereadable(path)
end

function M.is_directory(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

function M.can_exec(path)
  return 1 == fn.executable(path)
end

return M
