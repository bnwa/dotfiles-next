local opt = vim.opt_local
local bo = vim.bo

bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2
opt.wildignore:append '*/node_modules/*'
