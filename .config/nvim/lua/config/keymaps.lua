-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal handled by togglterm.nvim
vim.keymap.del("n", [[<leader>ft]])
vim.keymap.del("n", [[<leader>fT]])

-- Remap buffer search
vim.keymap.del("n", [[<leader>fb]])
vim.keymap.set("n", [[<leader>fl]], function() Snacks.picker.buffers() end, {
  desc = "Buffers"
})
