---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      local library = vim.api.nvim_get_runtime_file('lua', true)
      local path = vim.split(package.path, ';')
      table.insert(path, 1, 'lua/?/init.lua')
      table.insert(path, 1, 'lua/?.lua')
      return vim.tbl_deep_extend('force', opts, {
        servers = {
          lua_ls = {
            filetypes = {
              'lua',
            },
            settings = {
              -- https://luals.github.io/wiki/settings/
              Lua = {
                completion ={
                  -- When the input looks like a file name, automatically require the file.
                  autoRequire = false,
                  -- Whether to show call snippets or not. When disabled, only the function name will be completed. When enabled, a "more complete" snippet will be offered.
                  callSnippet = "Replace",
                  -- When a completion is being suggested, this setting will set the amount of lines around the definition to preview
                  displayContext = 0,
                  -- Whether to show a snippet for key words
                  keywordSnippet = "Replace",
                  --The character to use for triggering a "postfix suggestion". A postfix allows you to write some code and then trigger a snippet after (post) to "fix" the code you have written
                  postfix = '@',
                  -- Display a function's parameters in the list of completions. When a function has multiple definitions, they will be displayed separately.
                  showParams = true,
                  -- Display a function's parameters in the list of completions. When a function has multiple definitions, they will be displayed separately.
                  showWord = 'Fallback',
                  -- Whether words from other files in the workspace should be suggested as "contextual words".
                  workspaceWord = true,
                },
                diagnostics = {
                  -- Disable certain diagnostics globally.
                  disable = {},
                  -- An array of variable names that will be declared as global.
                  globals = { "MiniIcons", "vim", "Snacks" },
                },
                format = {
                  -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                  defaultConfig = {
                    align_array_table = 'true',
                    align_call_args = 'true',
                    align_continuous_assign_statement = 'true',
                    align_continuous_rect_table_field = 'true',
                    align_function_params = 'true',
                    align_if_branch = 'true',
                    break_all_list_when_line_exceed = 'true',
                    call_arg_parentheses = 'remove',
                    continuation_indent = '2',
                    end_of_line = 'unset',
                    indent_size = '2',
                    indent_style = 'space', -- space | tab
                    ignore_spaces_inside_function_call = 'true',
                    never_indent_before_if_condition = 'true',
                    quote_style = 'none', -- none | single | double
                    trailing_table_separator = 'always',
                    space_after_comma = 'true',
                    space_after_comma_in_for_statement = 'true',
                    space_around_concat_operator = 'true',
                    space_around_table_append_operator = 'true',
                    space_around_table_field_list = 'true',
                    space_around_math_operator = 'true',
                    space_before_attribute = 'true',
                    space_before_closure_open_parenthesis = 'false',
                    space_before_function_call_open_parenthesis = 'false',
                    space_before_function_call_single_arg = 'true',
                    space_before_function_open_parenthesis = 'false',
                    space_before_inline_comment = 'true',
                    space_inside_function_call_parentheses = 'false',
                    space_inside_function_param_list_parentheses = 'false',
                    space_inside_square_brackets = 'false',
                  },
                },
                hint = {
                  arrayIndex = 'Enable',
                  await = true,
                  paramName = true,
                  paramType = true,
                  semicolon = 'SameLine',
                  setType = true,
                },
                hover = {
                  enumsLimit = 8,
                  expandAlias = true,
                  previewFields = 50,
                  viewNumber = true, -- Enable hovering a non-decimal value to see its numeric value
                  viewString = true, -- For example, hovering "\x48" will display "H".
                },
                runtime = {
                  path = path,
                  version = 'LuaJIT',
                },
                workspace = {
                  checkThirdParty = 'Disable',
                  library = library
                },
              }
            },
            setup = function(config)
              --              local lazydev = require 'lazydev'
              --              lazydev.setup {
              --                library = {
              --                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
              --                }
              --              }
              config.root_dir = vim.fs.root(0, 'lazy-lock.json')
              return true
            end
          },
        }
      })
    end
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {}
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      'folke/lazydev.nvim',
    },
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  }
}
