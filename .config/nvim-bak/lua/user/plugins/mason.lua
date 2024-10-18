return {
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'Zeioth/mason-extra-cmds',
    },
    config = false,
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
  },
  {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
      },
      config = function()
        require('mason-null-ls').setup {
          ensure_installed = nil,
          automation_installation = true,
        }
      end,
  }
}
