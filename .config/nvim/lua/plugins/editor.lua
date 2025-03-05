return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = { virtcolumn = "66" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    "folke/trouble.nvim",
    ---@module 'trouble'
    ---@type trouble.Config
    opts = {
      auto_close = true,
      focus = true,
    },
    keys = {
      { "<leader>xx", false },
      { "<leader>xX", false },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      picker = {
        ---@type snacks.picker.lsp.symbols.Config
        ---@diagnostic disable-next-line:missing-fields
        lsp_symbols = {
          filter = {
            default = true,
            lua = {
              "Class",
              "Constructor",
              "Enum",
              "Field",
              "Function",
              "Interface",
              "Method",
              "Module",
              "Namespace",
              -- "Package", -- remove package since luals uses it for control flow structures
              "Property",
              "Struct",
              "Trait",
              "Variable",
            },
          },
        },
      },
    },
    keys = {
      { "<leader>fb>", false },
      {
        "<leader>fl",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
    },
  },
}
