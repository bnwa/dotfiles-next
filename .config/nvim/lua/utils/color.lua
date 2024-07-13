local time = require("utils.time")
local opt = vim.opt

local M = {}

---Sets 'background' option to 'light' or 'dark' given min and max wall clock thresholds in 24h format
---@param min integer[] # A list of two integers, first specifying hour in 24h format, second specifying minutes
---@param max integer[] # A list of two integers, first specifying hour in 24h format, second specifying minutes
function M.light_or_dark_mode(min, max)
  if time.between(min, max) then
    opt.background = "dark"
  else
    opt.background = "light"
  end
end

return M
