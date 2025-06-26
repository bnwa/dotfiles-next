---@module 'lazy'
---@type LazySpec[]
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    -- enabled = function()
    --   return type(vim.env.ANTHROPIC_API_KEY) == 'string'
    -- end,
    ---@module 'avante'
    ---@type avante.Config
    ---@diagnostic disable-next-line:missing-fields
    opts = function()
      local has_claude = type(vim.env.ANTHROPIC_API_KEY) == 'string'
      local provider = has_claude and 'claude' or 'copilot'
      return {
        mode = 'legacy',
        provider = provider,
        auto_suggestions_provider = provider,
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-sonnet-4-20250514",
            timeout = 30000, -- Timeout in milliseconds
            context_window = 200000,
            extra_request_body = {
              temperature = 0.75,
              max_tokens = 64000,
            },
          },
          copilot = {
            endpoint = "https://api.githubcopilot.com",
            model = "gpt-4o-2024-11-20",
            proxy = nil, -- [protocol://]host[:port] Use this proxy
            allow_insecure = false, -- Allow insecure server connections
            timeout = 30000, -- Timeout in milliseconds
            context_window = 128000, -- Number of tokens to send to the model for context
            extra_request_body = {
              temperature = 0.75,
              max_tokens = 20480,
            },
          },
        },
        file_selector = {
          file_selector = 'fzf_lua'
        },
        selector = {
          provider = 'fzf_lua',
        },
        web_search_engine = {
          provider = 'google'
        },
        disabled_tools = { 'python' },
      }
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      'zbirenbaum/copilot.lua',
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
  },
}
