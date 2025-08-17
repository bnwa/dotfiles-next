local str = require 'config.utils.str'
local fn = vim.fn

local M = {}

M.arch = {
  arm64 = jit.arch == 'arm64',
  x86 = jit.arch == 'x86',
  x64 = jit.arch == 'x64',
}

M.os = {
  mac = fn.has 'mac' == 1,
  win = fn.has 'win64' == 1,
  linux = fn.has 'linux' == 1,
  unix = fn.has 'unix' == 1,
}

--- Execute platform command line
--- @param cmd string[]
--- @return boolean
--- @return string
function M.exec(cmd)
  local done = vim.system(cmd):wait()
  local success = done.code == 0
  local stderr = done.stderr
  local stdout = done.stdout
  if not success then
    local msg = stderr and str.from_term(stderr) or ""
    return false, msg
  end
  local result = stdout and str.from_term(stdout) or ""
  return true, result
end

return M
