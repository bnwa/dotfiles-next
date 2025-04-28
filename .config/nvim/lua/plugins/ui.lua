---@module 'lazy'
---@type LazySpec[]
return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    opts = {
      graph_style = "unicode",
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      float_opts = {
        border = "double",
        title_pos = "center",
      },
      open_mapping = [[<c-\>]],
    },
    -- stylua: ignore start
    keys = {
      {
        [[<c-/>]],
        function() vim.cmd("ToggleTerm dir=" .. vim.fn.fnamemodify("%", "p:h")) end,
        desc = "Toggle floating terminal on current file's directory",
        mode = { 'n', 't' }
      },
      {
        [[<c-\>]],
        function() vim.cmd "ToggleTerm" end,
        desc = "Toggle floating terminal on current working directory",
        mode = { 'n', 't' }
      }
    },
    -- stylua: ignore end
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_b = {
          {
            "branch",
            --- @param str string
            --- @return string
            fmt = function(str)
              if str:len() > 16 then
                return str:sub(1, 16)
              else
                return str
              end
            end,
          },
        },
      },
    },
  },
  {
    "yarospace/lua-console.nvim",
    lazy = true,
    opts = {
      mappings = {
        toggle = false,
        attach = false,
      },
    },
    keys = {
      {
        "<leader>ft",
        function()
          require("lua-console").toggle_console()
        end,
        desc = "Toggle Lua Console",
      },
      {
        "<leader>fT",
        function()
          require("lua-console").attach_toggle()
        end,
        desc = "Attach Lua Console",
      },
    },
  },
  {
    "mgierada/lazydocker.nvim",
    dependencies = { "akinsho/toggleterm.nvim" },
    enabled = function()
      local path = require("user.utils.path")
      return path.can_exec("docker") and path.can_exec("lazydocker")
    end,
    event = "VeryLazy",
    config = function()
      require("lazydocker").setup({
        border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
      })
    end,
    keys = {
      {
        "<leader>z",
        function()
          require("lazydocker").open()
        end,
        desc = "Open Lazydocker floating window",
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module 'snacks.nvim'
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        ui_select = true,
      },
    },
  }
}
