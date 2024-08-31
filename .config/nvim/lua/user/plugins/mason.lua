return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'nvim-java/nvim-java',
      'williamboman/mason.nvim',
      'Zeioth/mason-extra-cmds',
    },
    config = function()end,
  },
  {
    "Zeioth/mason-extra-cmds",
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {},
  },
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    opt = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    config = function(_, opts)
      local mason = require 'mason'
      mason.setup(opts)
    end,
  },
}
