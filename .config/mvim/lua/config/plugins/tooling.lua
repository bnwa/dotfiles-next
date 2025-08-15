---@module 'lazy'
---@type LazySpec[]
return {
  {
    'williamboman/mason.nvim',
    version = "2.x",
    build = ':MasonUpdate',
    dependencies = {
      { "Zeioth/mason-extra-cmds", opts = {} },
    },
    ---@module 'mason'
    ---@type MasonSettings
    opts = {
      registries = {
        'github:mason-org/mason-registry',
      },
      ui = {
        border = 'rounded',
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    }
  },
  {
    'williamboman/mason-lspconfig.nvim',
    version = "2.x",
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {},
  },
}
