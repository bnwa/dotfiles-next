---@module 'lazy'
---@type LazySpec[]
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = vim.g.neovide and "mellifluous" or "melange",
    },
  },
}
