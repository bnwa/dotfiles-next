local server_config = require 'user.settings.lsp.typescript'

local ft = {
  'javascript',
  'javascriptreact',
  'typescriptscript',
  'typescriptreact',
}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'yioneko/nvim-vtsls',
    },
    ft = ft,
    opts = {
      servers = {
        vtsls = {
          setup = function(config)
            local lsp = require 'lspconfig'
            require('lspconfig.configs').vtsls = require('vtsls').lspconfig
            lsp.vtsls.setup(config)
          end,
          server_config = server_config,
        },
      }
    }
  },
}
