local M = {}

local function keymap(modes, lhs, rhs, opts)
  opts = opts and vim.tbl_extend('force', { silent = true }, opts) or { silent = true }
  vim.keymap.set(modes, lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  keymap('n', lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  keymap('i', lhs, rhs, opts)
end

return M

