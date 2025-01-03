local keymap = require 'user.settings.keymap'

--- @module 'lazy.types'
--- @type LazySpec
return {
  "folke/which-key.nvim",
  dependencies = {
    'echasnovski/mini.icons',
  },
  opts = {
    preset = 'modern',
    spec = keymap,
    win = {
      border = 'rounded'
    }
  },
}
