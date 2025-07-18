local M = {}

function M.accum_jdk_paths(tbl, str)
  str = vim.trim(str)
  local name_start_idx = string.find(str, '"', 1, true)
  local path_start_idx = string.find(str, "/", 1, true)
  local ver_str = string.sub(str, 3, 3) == "." and string.sub(str, 1, 2)
    or string.sub(str, 2, 2) == "." and string.sub(str, 1, 1) == "1" and string.sub(str, 1, 3)
    or string.sub(str, 2, 2) == "." and string.sub(str, 1, 1)
    or ""

  if not path_start_idx then
    return tbl
  end
  if not name_start_idx then
    return tbl
  end
  if ver_str == "" then
    return tbl
  end

  table.insert(tbl, {
    name = "JavaSE-" .. ver_str,
    path = string.sub(str, path_start_idx),
    version = tonumber(ver_str),
  })

  return tbl
end

function M.get_jdk_paths()
  local java_home_bin = "/usr/libexec/java_home"
  if vim.fn.executable(java_home_bin) == 1 then
    local output = vim.fn.systemlist({ java_home_bin, "-V" })
    return vim.fn.reduce(vim.list_slice(output, 1, #output - 1), M.accum_jdk_paths, {})
  end
  return {}
end

return M
