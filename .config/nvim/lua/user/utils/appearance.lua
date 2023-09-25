local M = {}

function M.is_dark_mode()
  local date_str = os.date()
  local date_parts = vim.split(date_str, '[%s%p]+')
  local date_hour = vim.fn.str2nr(date_parts[4])
  local is_night = date_hour >= 19 or date_hour < 7

  return is_night
end

return M
