-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local cmd = vim.cmd
local opt = vim.opt

--vim.g.autoformat = false

opt.cmdheight = 0 -- Hide command-line unless in use
opt.diffopt:append 'algorithm:histogram' -- Diff with histogram algo
opt.diffopt:append 'linematch:80' -- Recommend line cutoff for diff hunk
opt.listchars.extends = "»" -- Show this char when line excedes window right
opt.listchars.precedes = "«" -- Show this char when line excedes window left
opt.mousescroll.hor = 1 -- Disable horizontal mouse scroll
opt.mousescroll.ver = 1 -- Scroll 1 line per mouse wheel tick
opt.shada = "!,h,'1000,<50,s10" -- Configure shada file
opt.updatecount = 200 -- Number of characters typed at which to write swap

if vim.g.neovide then
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_theme = "auto"
  cmd.cd("~")
end
