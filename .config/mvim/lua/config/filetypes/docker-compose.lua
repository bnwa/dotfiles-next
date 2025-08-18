---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.docker_compose',
    virtual = true,
    config = function()
      vim.filetype.add({
        pattern = {
          ['docker%-compose%.ya?ml'] = 'docker-compose',
          ['docker%-compose%..*%.ya?ml'] = 'docker-compose',
          ['compose%.ya?ml'] = 'docker-compose',
        },
      })

      -- Register docker-compose filetype to use yaml treesitter parser
      vim.treesitter.language.register('yaml', 'docker-compose')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'docker-compose',
        callback = function()
          -- Set buffer options
          vim.bo.syntax = 'yaml'
          vim.bo.tabstop = 2
          vim.bo.shiftwidth = 2
          vim.bo.expandtab = true
          vim.bo.commentstring = '# %s'
          vim.bo.indentexpr = 'GetYAMLIndent()'
        end,
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {
        'docker_compose_language_service',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = function (_, opts)
      local tbl = require 'config.utils.tbl'

      return tbl.wild_deep_merge({'servers.*.filetypes'}, opts, {
        servers = {
          yamlls = {
            filetypes = { 'docker-compose' },
          },
          docker_compose_language_service = {
            filetypes = { 'docker-compose' },
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
      })
    end
  }
}
