local M = {}

--- Deep merge tables with wildcard path extension support
--- @param extend_paths string[] List of dot-separated paths that should extend lists
--- @param ... table Tables to merge (left to right)
--- @return table Merged result
function M.wild_deep_merge(extend_paths, ...)
  local tables = { ... }
  if #tables == 0 then
    return {}
  end

  -- Convert string paths to path component arrays
  local parsed_extend_paths = {}
  for _, path_string in ipairs(extend_paths) do
    local components = vim.split(path_string, ".", { plain = true })
    table.insert(parsed_extend_paths, components)
  end

  -- Helper to get value at path
  local function get_at_path(tbl, path)
    local current = tbl
    for _, key in ipairs(path) do
      if type(current) ~= "table" or current[key] == nil then
        return nil
      end
      current = current[key]
    end
    return current
  end

  -- Helper to set value at path
  local function set_at_path(tbl, path, value)
    local current = tbl
    for i = 1, #path - 1 do
      local key = path[i]
      if type(current[key]) ~= "table" then
        current[key] = {}
      end
      current = current[key]
    end
    current[path[#path]] = value
  end

  -- Helper to find all actual paths in a table that match a pattern
  local function find_matching_paths(tbl, pattern_path, current_path)
    current_path = current_path or {}
    local matches = {}

    if #current_path == #pattern_path then
      -- Check if current path matches pattern
      local matches_pattern = true
      for i = 1, #current_path do
        if pattern_path[i] ~= "*" and pattern_path[i] ~= current_path[i] then
          matches_pattern = false
          break
        end
      end
      if matches_pattern then
        table.insert(matches, vim.deepcopy(current_path))
      end
      return matches
    end

    if #current_path < #pattern_path and type(tbl) == "table" then
      local next_pattern_key = pattern_path[#current_path + 1]

      if next_pattern_key == "*" then
        -- Wildcard - check all keys
        for key, value in pairs(tbl) do
          local new_path = vim.list_extend(vim.deepcopy(current_path), { key })
          vim.list_extend(matches, find_matching_paths(value, pattern_path, new_path))
        end
      else
        -- Specific key
        if tbl[next_pattern_key] ~= nil then
          local new_path = vim.list_extend(vim.deepcopy(current_path), { next_pattern_key })
          vim.list_extend(matches, find_matching_paths(tbl[next_pattern_key], pattern_path, new_path))
        end
      end
    end

    return matches
  end

  -- First pass: collect all matching paths and their list values
  local path_lists = {}  -- Dictionary: path_key -> {list1, list2, ...}

  for _, table_data in ipairs(tables) do
    for _, extend_pattern in ipairs(parsed_extend_paths) do
      local matching_paths = find_matching_paths(table_data, extend_pattern)

      for _, actual_path in ipairs(matching_paths) do
        local value = get_at_path(table_data, actual_path)

        if value ~= nil then
          -- Validate that value is a list
          if not vim.islist(value) then
            error("Value at path " .. table.concat(actual_path, ".") .. " is not a list but template expects extension")
          end

          local path_key = table.concat(actual_path, ".")
          if not path_lists[path_key] then
            path_lists[path_key] = {}
          end
          table.insert(path_lists[path_key], value)
        end
      end
    end
  end

  -- Second pass: normal deep merge
  local result = vim.tbl_deep_extend("force", unpack(tables))

  -- Third pass: set concatenated lists at collected paths
  for path_key, lists in pairs(path_lists) do
    local path_components = vim.split(path_key, ".", { plain = true })
    local concatenated_list = {}

    for _, list in ipairs(lists) do
      vim.list_extend(concatenated_list, list)
    end

    set_at_path(result, path_components, concatenated_list)
  end

  return result
end

return M
