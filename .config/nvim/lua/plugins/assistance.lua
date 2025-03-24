local path = require 'user.utils.path'

local has_copilot = function()
  local auth_path =  vim.fn.expand("~/.config/github-copilot")
  return path.is_directory(auth_path)
end

local has_claude = function()
  return type(vim.env.ANTHROPIC_API_KEY) == 'string' and
  string.len(vim.env.ANTHROPIC_API_KEY) > 0
end


---@module 'lazy'
---@type LazySpec[]
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    enabled = function()
      return has_copilot() or has_claude()
    end,
    opts = function()
      local provider = has_copilot() and "copilot" or "claude"
      ---@module 'avante'
      ---@type avante.Config
      ---@diagnostic disable-next-line:missing-fields
      return {
        -- Default configuration
        hints = { enabled = false },

        ---@type "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
        provider = provider, -- Recommend using Claude
        auto_suggestions_provider = provider, -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot

        file_selector = {
          ---@type "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
          provider = "snacks", -- Avoid native provider issues
          provider_opts = {},
        },

        web_search_engine = {
          provider = 'google'
        },
      }
    end,
    build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
  },
  {
    "saghen/blink.cmp",
    lazy = true,
    dependencies = { "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "avante_commands", "avante_mentions", "avante_files" },
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
        -- LSP score_offset is typically 60
        providers = {
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90,
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 100,
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000,
            opts = {},
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = function(_, ft)
      return vim.list_extend(ft, { "Avante" })
    end,
    opts = function(_, opts)
      opts.file_types = vim.list_extend(opts.file_types or {}, { "Avante" })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
}
