local platform = require 'user.utils.platform'
local opt = vim.opt

local M = {}

function M.light_or_dark_mode()
  local ok, is_dark = platform.dark_mode()
  if ok and is_dark then
    opt.background = 'dark'
  else
    opt.background = 'light'
  end
end

return M
