return {
  "nvimtools/none-ls.nvim",
  name = 'null-ls',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'williamboman/mason.nvim',
    'ckolkey/ts-node-action',
  },
  opts = function()
    local null = require 'null-ls'
    local sources = {
      null.builtins.code_actions.ts_node_action,
    }
    return {
      debug = true,
      sources = sources,
    }
  end
}
