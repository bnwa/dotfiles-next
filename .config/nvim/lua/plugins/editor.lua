--- @type LazySpec[]
return {
  {
    "tzachar/highlight-undo.nvim",
  },
  {
    "cappyzawa/trim.nvim",
    opts = {},
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    config = function()
      require("virt-column").setup({ char = "▕" })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  }
}
