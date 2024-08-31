local keymap = require 'user.settings.keymap'

return {
  "folke/which-key.nvim",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    preset = 'modern',
    spec = keymap,
    win = {
      border = 'rounded'
    }
  },
}
