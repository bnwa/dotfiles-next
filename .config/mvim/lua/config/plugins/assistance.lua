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
    opts = function()
      local has_claude = type(vim.env.ANTHROPIC_API_KEY) == 'string'
      local provider = has_claude and 'claude' or 'copilot'
      ---@module 'avante'
      ---@type avante.Config
      return {
        auto_suggestions_provider = provider,
        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
        disabled_tools = {
          'python',        -- Claude goes nuts w/ Python
          "list_files",    -- MCPHub provides the tools from here
          "search_files",
          "read_file",
          "create_file",
          "rename_file",
          "delete_file",
          "create_dir",
          "rename_dir",
          "delete_dir",
          "bash",
        },
        file_selector = {
          file_selector = 'snacks'
        },
        input = {
          provider = 'snacks',
        },
        mode = 'legacy',
        provider = provider,
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
        rules = {
          global_dir = vim.fn.expand '~/.config/mvim/avante/rules',
          project_dir = '.avante/rules',
        },
        selector = {
          provider = 'snacks',
        },
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end,
        web_search_engine = {
          provider = 'google'
        },
        windows = {
          position = "right",
          input = {
            height = 16,
          },
        },
      }
    end,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
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
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        build = "bundled_build.lua",  -- Bundles `mcp-hub` binary along with the neovim plugin
        config = function()
          require("mcphub").setup({
            extensions = {
              avante = {
                make_slash_commands = true, -- make /slash commands from MCP server prompts
              }
            },
            use_bundled_binary = true,  -- Use local `mcp-hub` binary
          })
        end,
      }
    },
  },
}
