local str = require("user.utils.str")
local fn = vim.fn

local arch = {
  arm64 = jit.arch == "arm64",
  x86 = jit.arch == "x86",
  x64 = jit.arch == "x64",
}

local os = {
  mac = fn.has("mac") == 1,
  win = fn.has("win64") == 1,
  linux = fn.has("linux") == 1,
  unix = fn.has("unix") == 1,
}

--- Execute platform command line
--- @param cmd string[]
--- @return boolean ok whether IO completed succesfully or not
--- @return string result when ok, boolean; err string otherwise
local function exec(cmd)
  local done = vim.system(cmd):wait()
  local success = done.code == 0
  local stderr = done.stderr
  local stdout = done.stdout
  if not success then
    if stderr == nil then
      return false, ""
    else
      local err_msg = str.from_term(stderr)
      return false, err_msg
    end
  end
  if stdout == nil then
    return true, ""
  end
  local output = str.from_term(stdout)
  return true, output
end

return {
  arch = arch,
  os = os,
  exec = exec,
}
