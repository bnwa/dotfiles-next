-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local cmd = vim.cmd
local opt = vim.opt
opt.listchars.extends = "»" -- Show this char when line excedes window right
opt.listchars.precedes = "«" -- Show this char when line excedes window left
vim.g.autoformat = false
if vim.g.neovide then
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_theme = "auto"
  cmd.cd("~")
end
