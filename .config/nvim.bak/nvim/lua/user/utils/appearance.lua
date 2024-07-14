local time = require 'user.utils.time'
local M = {}

function M.toggle_light_dark_mode()
  if time.is_night() then
    vim.opt.background = 'dark'
  else
    vim.opt.background = 'light'
  end
end

return M
