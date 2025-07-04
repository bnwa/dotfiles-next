---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/schemastore.nvim'
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts, {
        servers = {
          yamlls = {
            filetypes = {
              'yaml',
            },
            settings =  {
              yaml = {
                completion = true,
                format = {
                  enable = true,
                  bracketSpacing = true,
                  printWidth = 80,
                  singleQuote = false,
                },
                hover = true,
                schemas = require('schemastore').yaml.schemas(),
                schemaStore = {
                  enable = false,
                  url = "",
                },
                validate = true,
              }
            }
          }
        }
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'yaml' }
    }
  }
}
