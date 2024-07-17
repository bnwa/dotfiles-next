local color = require 'user.utils.color'
local cmd = vim.cmd

local colorscheme = vim.g.colorscheme

if not vim.g.neovide then
  color.light_or_dark_mode()
end

if not pcall(cmd.colorscheme, colorscheme) then
  vim.notify('Failed to colorscheme' .. colorscheme)
end
