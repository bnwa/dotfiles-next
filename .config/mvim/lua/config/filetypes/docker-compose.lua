---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.docker_compose',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'
      autocmd.filetype({'yaml.docker-compose', 'yml.docker-compose'}, function()
        vim.bo.ts = 2
        vim.bo.sw = 2
      end)
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {
        'docker_compose_language_server',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        docker_compose_language_server = {
          filetypes = {
            'yaml.docker-compose',
            'yml.docker-compose'
          },
          settings = {
            dockerCompose = {
              -- Enable/disable completion suggestions
              completion = {
                enabled = true,
                -- Include service names in completion
                includeServices = true,
                -- Include network names in completion
                includeNetworks = true,
                -- Include volume names in completion
                includeVolumes = true,
              },
              -- Validation and diagnostic settings
              validation = {
                -- Enable/disable schema validation
                enabled = true,
                -- Validate service definitions
                services = true,
                -- Validate network configurations
                networks = true,
                -- Validate volume definitions
                volumes = true,
                -- Validate environment variable syntax
                environment = true,
                -- Validate port mapping syntax
                ports = true,
                -- Check for duplicate service names
                duplicateServiceNames = "error",
                -- Check for invalid service references
                invalidServiceReferences = "error",
                -- Validate compose file version
                composeVersion = "warning",
              },
              -- Formatting settings
              formatting = {
                -- Enable/disable document formatting
                enabled = true,
                -- Indent size for YAML
                indentSize = 2,
                -- Use spaces instead of tabs
                insertSpaces = true,
              },
              -- Hover information settings
              hover = {
                -- Enable/disable hover documentation
                enabled = true,
                -- Show service documentation on hover
                showServiceDocs = true,
                -- Show property documentation on hover
                showPropertyDocs = true,
              },
              -- Schema settings
              schema = {
                -- Compose specification version: "3.0", "3.8", "latest"
                version = "latest",
                -- Enable strict schema validation
                strict = false,
                -- Allow additional properties not in schema
                allowAdditionalProperties = true,
              },
            },
          }
        }
      }
    }
  }
}
