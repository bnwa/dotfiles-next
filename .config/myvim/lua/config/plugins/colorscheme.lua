---@module 'lazy'
---@type LazySpec[]
return {
  {
    'echasnovski/mini.colors',
    version = '*',
    config = true,
  },
  {
    'ramojus/mellifluous.nvim',
    lazy = false,
    priority = 100,
    opts = {}
  },
  {
    'savq/melange-nvim',
    lazy = false,
    priority = 100,
  },
}
