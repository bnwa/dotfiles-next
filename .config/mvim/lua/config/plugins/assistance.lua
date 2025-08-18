---@module 'lazy'
---@type LazySpec[]
return {
  {
    'olimorris/codecompanion.nvim',
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
        extensions = {
          vectorcode = {
            ---@module "vectorcode"
            ---@type VectorCode.CodeCompanion.ExtensionOpts
            opts = {
              tool_group = {
                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                enabled = true,
                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                -- if you use @vectorcode_vectorise, it'll be very handy to include
                -- `file_search` here.
                extras = {},
                collapse = false, -- whether the individual tools should be shown in the chat
              },
              tool_opts = {
                ---@type VectorCode.CodeCompanion.ToolOpts
                ["*"] = {},
                ---@type VectorCode.CodeCompanion.LsToolOpts
                ls = {},
                ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                vectorise = {},
                ---@type VectorCode.CodeCompanion.QueryToolOpts
                query = {
                  max_num = { chunk = -1, document = -1 },
                  default_num = { chunk = 50, document = 10 },
                  include_stderr = false,
                  use_lsp = true,
                  no_duplicate = true,
                  chunk_mode = false,
                  ---@type VectorCode.CodeCompanion.SummariseOpts
                  summarise = {
                    ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                    enabled = false,
                    adapter = nil,
                    query_augmented = true,
                  }
                },
                files_ls = {},
                files_rm = {}
              }
            },
          },
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              -- MCP Tools
              make_tools = true,              -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true,      -- Show tool results directly in chat buffer
              format_tool = nil,               -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true,                -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true,      -- Add MCP prompts as /slash commands
            }
          },
        },
        opts = {
          log_level = 'INFO',
        },
        strategies = {
          chat = {
            adapter = provider,
            opts = {
              completion_provider = 'blink',
            },
            ---@module 'codecompanion'
            ---@type table<string,CodeCompanion.Tools.Tool>
            tools = {
              create_vector_index = {
                description = "Initialize a vector index for a directory path",
                name = "create_vector_index",
                cmds = {
                  function(_, args)
                    local platform = require 'config.utils.platform'
                    local bin = vim.env.MASON .. '/bin/vectorcode'
                    local path = args.abs_path
                    local glob = args.glob
                    local init = { bin, 'init', '--project_root', path, }
                    local index = { bin, 'vectorise', path .. '/' .. glob }

                    local init_ok, init_msg = platform.exec(init)
                    if not init_ok then
                      return { status = 'error', data = init_msg }
                    end

                    local index_ok, index_msg = platform.exec(index)
                    if not index_ok then
                      return { status = 'error', data = index_msg }
                    end

                    return { status = 'success' }
                  end
                },
                schema = {
                  type = 'function',
                  ['function'] = {
                    description = "Initialize a vector index for a directory path",
                    name = "create_vector_index",
                    parameters = {
                      type = 'object',
                      properties = {
                        path =  {
                          type = 'string',
                          description = 'An absolute path to a direcory to create a vector index for'
                        },
                        glob = {
                          type = 'string',
                          description =  'A valid glob representing files to vector index',
                        },
                      },
                      required = {
                        'path',
                        'glob',
                      },
                      additionalProperties = false,
                    }
                  },
                  strict = true,
                },
              },
              has_vector_index = {
                description = "Check if the current working directory has a vector index to query",
                name = "has_vector_index",
                cmds = {
                  function()
                    local db = require 'vectorcode'
                    local result = db.check('config')
                    return { status = 'success', data = result }
                  end
                },
                schema = {
                  type = 'function',
                  ['function'] = {
                    description = "Check if the current working directory has a vector index to query",
                    name = "has_vector_index",
                    parameters = {
                      type = 'object',
                      properties = vim.empty_dict(),
                      required = {},
                      additionalProperties = false,
                    }
                  },
                  strict = true,
                }
              }
            },
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
      'Davidyz/VectorCode',
      'ravitemer/mcphub.nvim',
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
  {
    "Davidyz/VectorCode",
    version = "*", -- optional, depending on whether you're on nightly or release
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        opts = {
          ensure_installed = {
            'vectorcode_server'
          }
        }
      },
    },
    main = 'vectorcode.config',
    opts = {},
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua",  -- Bundles `mcp-hub` binary along with the neovim plugin
    config = function()
      require("mcphub").setup({
        use_bundled_binary = true,  -- Use local `mcp-hub` binary
      })
    end,
  }
}
