local platform = require("user.utils.platform")

local M = {}

--- @return boolean ok whether IO completed succesfully or not
--- @return boolean|string result when ok, boolean; err string otherwise
local function is_dark_mode()
  if not platform.os.mac then
    return false, "OS must be Darwin"
  end
  local ok, mode = platform.exec({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  if not ok then
    return false, mode
  elseif vim.trim(mode) == "Dark" then
    return true, true
  else
    return true, false
  end
end

function M.toggle_bg()
  local ok, dark_mode = is_dark_mode()
  if ok and dark_mode then
    vim.opt.background = "dark"
  else
    vim.opt.background = "light"
  end
end

return M
