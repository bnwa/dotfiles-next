-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = require("user.utils.autocmd")
local colorscheme = require("user.utils.colorscheme")

if not vim.g.neovide then
  -- stylua: ignore start
  autocmd.event({ "FocusGained", "FocusLost" }, { "*" },
    "Toggle background when focus changes",
    function()
      colorscheme.toggle_bg()
    end)
  -- stylua: ignore end
end

autocmd.filetype({ "html", "java", "markdown", "sql", "xml", "fish" }, function(evt)
  vim.bo[evt.buf].shiftwidth = 4
  vim.bo[evt.buf].tabstop = 4
end)
