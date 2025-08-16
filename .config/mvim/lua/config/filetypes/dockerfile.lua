---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.dockerfile',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'
      autocmd.filetype({'dockerfile'}, function()
        vim.bo.ts = 4
        vim.bo.sw = 4
      end)
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {
        'docker_language_server',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        docker_language_server = {
          filetypes = {
            'dockerfile'
          },
          settings = {
            docker = {
              languageserver = {
                completion = {
                  -- Enable/disable completion suggestions
                  enabled = true,
                },
                diagnostics = {
                  -- Enable/disable all diagnostic features
                  enabled = true,
                  -- Warn about deprecated MAINTAINER instruction: "ignore", "warning", "error"
                  deprecatedMaintainer = "warning",
                  -- Warn about empty continuation lines: "ignore", "warning", "error"
                  emptyContinuationLine = "warning",
                  -- Warn about instruction casing: "ignore", "warning", "error"
                  instructionCasing = "warning",
                  -- Required casing style: "lowercase", "uppercase"
                  instructionCasingRequirement = "uppercase",
                  -- Warn about JSON in single quotes: "ignore", "warning", "error"
                  instructionJSONInSingleQuotes = "warning",
                  -- Warn about multiple instructions on same line: "ignore", "warning", "error"
                  instructionMultiple = "warning",
                  -- Warn about relative paths in WORKDIR: "ignore", "warning", "error"
                  instructionWorkdirRelative = "warning",
                },
                formatting = {
                  -- Enable/disable document formatting
                  enabled = true,
                  -- Skip formatting multiline instructions
                  ignoreMultilineInstructions = false,
                },
                hover = {
                  -- Enable/disable hover information
                  enabled = true,
                },
              },
            },
          }
        }
      }
    }
  }
}
