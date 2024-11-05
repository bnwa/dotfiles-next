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
}
