local keymap = require 'user.settings.keymap'

return {
  {
    "folke/which-key.nvim",
    event = { 'VeryLazy' },
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
  },

}
