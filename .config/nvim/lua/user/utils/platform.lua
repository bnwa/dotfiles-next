local fn = vim.fn
local uv = vim.uv

local arch = jit.arch

return {
  arch = {
    arm64 = arch == 'arm64',
    x86 = arch == 'x86',
    x64 = arch == 'x64',
  },
  os = {
    mac = fn.has 'mac' == 1,
    win = fn.has 'win64' == 1,
    linux = fn.has 'linux' == 1,
    unix = fn.has 'unix' == 1,
  },
}
