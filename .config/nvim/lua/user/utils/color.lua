local time = require 'user.utils.time'
local opt = vim.opt
local g = vim.g

local M = {}

function M.light_or_dark_mode()
  local min_night_time = g.min_night_time
  local max_night_time = g.max_night_time
  if not min_night_time or not max_night_time then
    return
  end

  if time.between(min_night_time, max_night_time) then
    opt.background = "dark"
  else
    opt.background = "light"
  end
end

return M
