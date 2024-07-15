local color = require 'user.utils.color'
local opt = vim.opt
local cmd = vim.cmd

if not vim.g.neovide then
  color.light_or_dark_mode()
end

cmd.colorscheme 'melange'
