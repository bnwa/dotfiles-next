---@module 'lazy'
---@type LazySpec[]
return {
  {
    "olimorris/codecompanion.nvim",
    opts = function()
      local has_claude = type(vim.env.ANTHROPIC_API_KEY) == 'string'
      local provider = has_claude and 'anthropic' or 'copilot'
      return {
        adapters = {
          anthropic = require('codecompanion.adapters').extend('anthropic', {
            schema = {
              max_tokens = {
                default = 64000
              },
              model = {
                default = 'claude-sonnet-4-20250514'
              },
            }
          }),
          copilot = require('codecompanion.adapters').extend('copilot', {
            schema = {
              max_tokens = {
                default = 200000
              },
              model = {
                default = 'claude-sonnet-4'
              },
            }
          }),
        },
        display = {
          chat = {
            fold_context = true,
            icons = {
              chat_context = ''
            }
          },
          provider = 'snacks'
        },
        opts = {
          log_level = 'DEBUG',
        },
        strategies = {
          chat = {
            adapter = provider,
            variables = {
              ["buffer"] = {
                opts = {
                  default_params = 'watch', -- or 'pin'
                },
              },
            },
          },
          cmd = {
            adapter = provider,
          },
          inline = {
            adapter = provider,
          },
        },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'zbirenbaum/copilot.lua',
      {
        'HakonHarnes/img-clip.nvim',
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
      {
        'OXY2DEV/markview.nvim',
        opts = function(_, opts)
          local function conceal_tag(icon, hl_group)
            return {
              on_node = { hl_group = hl_group },
              on_closing_tag = { conceal = '' },
              on_opening_tag = {
                conceal = '',
                virt_text_pos = 'inline',
                virt_text = {{ icon .. ' ', hl_group }},
              },
            }
          end

          return vim.tbl_deep_extend('force', opts, {
            html = {
              container_elements = {
                ['^buf$']         = conceal_tag('', 'CodeCompanionChatVariable'),
                ['^file$']        = conceal_tag('', 'CodeCompanionChatVariable'),
                ['^help$']        = conceal_tag('󰘥', 'CodeCompanionChatVariable'),
                ['^image$']       = conceal_tag('', 'CodeCompanionChatVariable'),
                ['^symbols$']     = conceal_tag('', 'CodeCompanionChatVariable'),
                ['^url$']         = conceal_tag('󰖟', 'CodeCompanionChatVariable'),
                ['^var$']         = conceal_tag('', 'CodeCompanionChatVariable'),
                ['^tool$']        = conceal_tag('', 'CodeCompanionChatTool'),
                ['^user_prompt$'] = conceal_tag('', 'CodeCompanionChatTool'),
                ['^group$']       = conceal_tag('', 'CodeCompanionChatToolGroup'),
              },
            },
          })
        end,
      }
    },
  },
}
