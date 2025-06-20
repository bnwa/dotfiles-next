return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/schemastore.nvim',
    },
    opts = {
      servers = {
        ---@type vim.lsp.ClientConfig
        ---@diagnostic disable-next-line:missing-fields
        jsonls = {
          filetypes = {
            'json',
            'jsonc',
            'json5',
          },
          settings = {
            json = {
              allowComments = { enable = true },
              format = { enable = true },
              validate = { enable = true },
              schemas = {},
            }
          },
          setup = function(config)
            local schemas = require('schemastore').json.schemas()
            vim.list_extend(config.settings.json.schemas, schemas)
            return true
          end
        }
      }
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'json5', 'jsonc' }
    }
  }
}
