local M = {}

function M.between(min, max)
  local datetime = os.date("*t")
  local curr_hour = datetime.hour
  local curr_mins = datetime.min
  local min_hours = min[1]
  local min_minutes = min[2] or 0
  local max_hours = max[1]
  local max_minutes = max[2] or 0
  return curr_hour >= min_hours and curr_mins >= min_minutes and curr_hour < max_hours and curr_mins < max_minutes
end

return M
