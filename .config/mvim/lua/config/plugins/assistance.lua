---@module 'lazy'
---@type LazySpec[]
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    enabled = function()
      return type(vim.env.ANTHROPIC_API_KEY) == 'string'
    end,
    ---@module 'avante'
    ---@type avante.Config
    ---@diagnostic disable-next-line:missing-fields
    opts = {
      provider = 'claude',
      providers = {
        claudes = {
          max_tokens = 8192,
          model = 'claude-3-5-sonnet-20241022',
        }
      },
      file_selector = {
        file_selector = 'fzf'
      },
      web_search_engine = {
        provider = 'google'
      },
      disabled_tools = { 'python' },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        'OXY2DEV/markview.nvim',
        opts = {
          preview = {
            filetypes = { "Avante" }
          }
        },
      },
    },
  }
}
