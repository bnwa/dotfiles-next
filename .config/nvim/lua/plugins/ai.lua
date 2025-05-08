---@module 'lazy'
---@type LazySpec[]
return {
  -- All this to spec the model
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = function() return not vim.env.ANTHROPIC_API_KEY end,
    version = '*',
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        agent = 'copilot',
        model = 'claude-3.7-sonnet',
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
              if input ~= "" then
                require("CopilotChat").ask(input)
              end
            end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
  {
      "yetone/avante.nvim",
      event = "VeryLazy",
      version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      enabled = function()
        return type(vim.env.ANTHROPIC_API_KEY) == 'string' and
                vim.env.ANTHROPIC_API_KEY ~= ''
      end,
      ---@module 'avante'
      ---@type avante.Config
      ---@diagnostic disable-next-line:missing-fields
      opts = {
        provider = 'claude',
        claude = {
          max_tokens = 8192,
          model = 'claude-3-5-sonnet-20241022',
        },
        file_selector = {
          file_selector = 'fzf'
        },
        web_search_engine = {
          provider = 'google'
        }
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
              filetypes = { "md", "rmd", "quarto", "Avante" }
            }
          },
        },
      },
    }
}
