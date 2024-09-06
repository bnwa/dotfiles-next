local str = require 'user.utils.str'
local err = vim.api.nvim_err_writeln
local fn = vim.fn

local arch = {
  arm64 = jit.arch == 'arm64',
  x86 = jit.arch == 'x86',
  x64 = jit.arch == 'x64',
}

local os = {
  mac = fn.has 'mac' == 1,
  win = fn.has 'win64' == 1,
  linux = fn.has 'linux' == 1,
  unix = fn.has 'unix' == 1,
}

--- Execute platform command line
--- @param cmd string[]
--- @return boolean,string
local function exec(cmd)
  local done = vim.system(cmd):wait()
  local success = done.code == 0
  local stderr = done.stderr
  local stdout = done.stdout
  if not success then
    err(("[io.cmd] - Encountered error executing %s").format(fn.join(cmd)))
    if stderr == nil then
      return false, ""
    else
      local err_msg, _ = str.from_term(stderr)
      err(("%s").format(err_msg))
      return false, err_msg
    end
  end
  if stdout == nil then return true, "" end
  local output, _ = str.from_term(stdout)
  return true, output
end

return {
  arch = arch,
  os = os,
  ---@return boolean ok whether IO completed succesfully or not
  ---@return boolean|string result when ok, boolean; err string otherwise
  dark_mode = function()
    if not os.mac then return false,"OS must be Darwin" end
    local ok, mode = exec { 'defaults', 'read', '-g', 'AppleInterfaceStyle' }
    if not ok then
      return false,mode
    elseif vim.trim(mode) == 'Dark' then
      return true,true
    else
      return true,false
    end
  end,
  exec = exec,
}
