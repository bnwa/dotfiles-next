local M = {}

function M.map(tbl, f)
  return vim.tbl_map(f, tbl)
end

function M.filter(tbl, pred)
  return vim.tbl_filter(pred, tbl)
end

return M
