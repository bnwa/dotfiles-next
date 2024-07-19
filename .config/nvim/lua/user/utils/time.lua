local M = {}

function M.between(min, max)
  local datetime = os.date("*t")
  local curr_hours = datetime.hour
  local curr_mins = datetime.min
  local curr_is_am = curr_hours >= 0 and curr_hours < 12
  local min_hours = min[1]
  local min_minutes = min[2] or 0
  local min_is_am = min_hours >= 0 and min_hours < 12
  local max_hours = max[1]
  local max_minutes = max[2] or 0
  local max_is_am = max_hours >= 0 and max_hours < 12
  local gte_min = false
  local lte_max = false

  if min_is_am and curr_is_am or not min_is_am and not curr_is_am then
    gte_min = curr_hours > min_hours or curr_hours == min_hours and curr_mins >= min_minutes
  elseif min_is_am and not curr_is_am then
    gte_min = false
  elseif not min_is_am and curr_is_am then
    gte_min = true
  end

  if max_is_am and curr_is_am or not max_is_am and not curr_is_am then
    lte_max = curr_hours < max_hours or curr_hours == max_hours and curr_mins <= max_minutes
  elseif max_is_am and not curr_is_am then
    lte_max = false
  elseif not max_is_am and curr_is_am then
    lte_max = true
  end

  return gte_min and lte_max
end

return M
