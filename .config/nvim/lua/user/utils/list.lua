local M = {}

function M.append(ls, x)
  table.insert(ls, x)
  return #ls
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

function M.map(tbl, f)
  return vim.tbl_map(f, tbl)
end

function M.filter(tbl, pred)
  return vim.tbl_filter(pred, tbl)
end

return M
