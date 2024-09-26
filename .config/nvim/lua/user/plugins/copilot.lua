local path = require 'user.utils.path'

return {
  {
    "zbirenbaum/copilot-cmp",
    opts = {
      fix_pairs = false,
    },
    config = function (_, opts)
      require("copilot_cmp").setup(opts)
    end
  },
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = {
      panel = {
        enabled = false,
        keymap = {
          open = '<leader>c',
        }
      },
      suggestion = {
        enabled = false,
        keymap = {
          next = ']c',
          prev = '[c',
        }
      }
    }
  },
}
