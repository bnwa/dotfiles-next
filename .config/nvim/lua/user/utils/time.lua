local M = {}

function M.between(min, max)
  local datetime = os.date("*t")
  local curr_hours = datetime.hour
  local curr_mins = datetime.min
  local min_hours = min[1]
  local min_minutes = min[2] or 0
  local max_hours = max[1]
  local max_minutes = max[2] or 0
  local gte_min = curr_hours > min_hours or curr_hours == min_hours and curr_mins >= min_minutes
  local lte_max = gte_min and curr_hours > max_hours
    or curr_hours < max_hours
    or curr_hours == max_hours and curr_mins < max_minutes
  return gte_min and lte_max
end

return M
