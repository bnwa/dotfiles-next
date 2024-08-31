local path = require 'user.utils.path'

local brew_node = '/opt/Homebrew/bin/node'

return {
  {
    'zbirenbaum/copilot.lua',
    enabled = function() return path.can_exec(brew_node) end,
    event = 'InsertEnter',
    opts = {
      copilot_node_command = brew_node,
      panel = { enabled = false },
      suggestion = { enabled = false },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    opts = {
      fix_pairs = true,
    },
    config = function (_, opts)
      require("copilot_cmp").setup(opts)
    end
  },
}
