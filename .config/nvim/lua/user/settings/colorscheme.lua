local autocmd = require 'user.utils.autocmd'
local color = require 'user.utils.color'
local cmd = vim.cmd

local colorscheme = vim.g.colorscheme

if vim.g.neovide then
  vim.g.neovide_theme = 'auto' -- Neovide will manage light/dark mode
else
  color.light_or_dark_mode()
  autocmd.event("Toggle background when focus changes",
    { 'FocusGained', 'FocusLost' },
    { '*' },
    function()
      color.light_or_dark_mode()
    end)
end

if not pcall(cmd.colorscheme, colorscheme) then
  vim.notify('Failed to load colorscheme' .. colorscheme)
end
