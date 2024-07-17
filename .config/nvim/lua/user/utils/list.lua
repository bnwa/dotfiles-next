local M = {}

function M.is(x)
  return vim.islist(x)
end

function M.from_table(t)
  local ls = {}
  for _, x in pairs(t) do
    M.append(ls, x)
  end
  return ls
end

function M.append(ls, x)
  table.insert(ls, x)
  return ls
end

function M.contains(ls, x)
  return vim.list_contains(ls, x)
end

function M.slice(ls, head, tail)
  return vim.list_slice(ls, head, tail)
end

function M.concat(ls_a, ls_b)
  local ls_c = {}
  vim.list_extend(ls_c, ls_a)
  vim.list_extend(ls_c, ls_b)
  return ls_c
end

function M.map(ls, f)
  local result = {}
  for _, x in ipairs(ls) do
    M.append(result, f(x))
  end
  return result
end

function M.filter(ls, f)
  local result = {}
  for _, x in ipairs(ls) do
    if f(x) then
      M.append(result, x)
    end
  end
  return result
end

return M
