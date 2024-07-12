-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local color = require("utils.color")
local evt = require("utils.events")
local path = require("utils.path")
local cmd = vim.cmd
local opt = vim.opt
local wo = vim.wo

local NIGHT_MIN = { 20, 30 }
local NIGHT_MAX = { 7 }

opt.listchars.precedes = "«"
opt.listchars.extends = "»"
if jit.arch == "arm64" and path.can_exec("fish") then
  opt.shell = "/opt/homebrew/bin/fish -l"
else
  opt.shell = "/bin/zsh --login --interactive"
end
opt.splitbelow = false
opt.splitright = false
opt.undofile = true
opt.wildignore:append("/.git")

color.light_or_dark_mode(NIGHT_MIN, NIGHT_MAX)

if vim.g.neovide then
  vim.g.neovide_theme = "auto"
  vim.g.neovide_remember_window_size = true
  cmd.cd("~")
end

evt.on("*", { "FocusGained", "FocusLost" }, function()
  color.light_or_dark_mode(NIGHT_MIN, NIGHT_MAX)
end)

evt.on("*", { "TermOpen" }, function()
  wo.number = false
  wo.relativenumber = false
end)
