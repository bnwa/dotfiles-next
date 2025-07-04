local M = {}

--@param x any
--@return boolean
function M.is(x)
  return vim.islist(x)
end

---@generic T
---@param t { [string]: T }
---@return T[]
function M.from_table_values(t)
  local ls = {}
  for _, x in pairs(t) do
    M.append(ls, x)
  end
  return ls
end

---@param t { [string]: any }
---@return string[]
function M.from_table_keys(t)
  local ls = {}
  for k, _ in pairs(t) do
    M.append(ls,k)
  end
  return ls
end

---@generic T
---@param t { [string]: `T` }
---@return { [1]: string, [2]: T }[]
function M.from_table_entries(t)
  local ls = {}
  for k,v in pairs(t) do
    M.append(ls, {k, v})
  end
  return ls
end

---@generic T
---@param ... T
---@return T[]
function M.from(...)
  local ls = {}
  for x in ipairs(...) do
    M.append(ls, x)
  end
  return ls
end

---@generic T
---@param ls T[]
---@param x T
---@return T[]
function M.append(ls, x)
  table.insert(ls, x)
  return ls
end

---@generic T
---@param ls T[]
---@param x any
---@return boolean
function M.contains(ls, x)
  return vim.list_contains(ls, x)
end

---@generic T
---@param ls T[]
---@param head number
---@param tail number
---@return T[]
function M.slice(ls, head, tail)
  return vim.list_slice(ls, head, tail)
end

---@generic T
---@param ls_a T[]
---@param ls_b T[]
---@return T[]
function M.concat(ls_a, ls_b)
  local ls_c = {}
  vim.list_extend(ls_c, ls_a)
  vim.list_extend(ls_c, ls_b)
  return ls_c
end

---@generic T
---@generic U
---@param ls T[]
---@param f fun(x: T) : U
---@return U[]
function M.map(ls, f)
  local result = {}
  for _, x in ipairs(ls) do
    M.append(result, f(x))
  end
  return result
end

---@generic T
---@param ls T[]
---@param f fun(x: T) : boolean
---@return T[]
function M.filter(ls, f)
  local result = {}
  for _, x in ipairs(ls) do
    if f(x) then
      M.append(result, x)
    end
  end
  return result
end

---@generic T
---@param ls T[]
---@param f fun(a: T, b: T) : -1 | 0 | 1
---@return T[]
function M.sort(ls, f)
  if not M.is(ls) then return ls end
  return vim.fn.sort(vim.fn.copy(ls), f)
end

---@generic T
---@param tbl T[][]
---@return T[]
function M.flatten(tbl)
  local result = {}
  for _, ls in ipairs(tbl) do
    for _, elem in pairs(ls) do
      M.append(result, elem)
    end
  end
  return result
end

return M
