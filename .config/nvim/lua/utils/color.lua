local time = require("utils.time")
local opt = vim.opt

local M = {}

function M.light_or_dark_mode(min, max)
  if time.between(min, max) then
    opt.background = "dark"
  else
    opt.background = "light"
  end
end

return M
