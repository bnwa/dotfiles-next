local ft = {
  'json',
  'jsonc',
  'json5',
}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/schemastore.nvim'
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts, {
        servers = {
          jsonls = {
            filetypes = ft,
            server_config = {
              format = {
                enable = true,
              },
              schemas = require('schemastore').json.schemas(),
              validate = {
                enable = true,
              },
            },
          },
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'json5' }
    }
  }
}
