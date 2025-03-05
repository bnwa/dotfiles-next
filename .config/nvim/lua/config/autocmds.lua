-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local colorscheme = require("user.utils.colorscheme")
local augroup = vim.api.nvim_create_augroup('UserConfig', {  clear = true })
local autocmd = vim.api.nvim_create_autocmd


if not vim.g.neovide then
  autocmd({'FocusGained', 'FocusLost'}, {
    group = augroup,
    callback = function()
      colorscheme.toggle_bg()
    end
  })
end

autocmd({'FileType'}, {
  group = augroup,
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
  pattern = { "html", "java", "markdown", "sql", "xml", "fish" }
})
