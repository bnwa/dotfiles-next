local settings = require 'user.settings.lsp.java'
local autocmd = require 'user.utils.autocmd'
local path = require 'user.utils.path'

local fn = vim.fn
local fs = vim.fs

local ft = {'java'}

return {
  {
    'nvim-java/nvim-java',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jdtls = {
          filetypes = ft,
          on_attach = function(client, _)
            client.notify('workspace/didChangeConfiguration', {
              settings = settings
            })
          end,
          settings = settings,
          setup = function(config)
            require('java').setup {}
            require('lspconfig').jdtls.setup(config)
          end,
        },
      },
    },
  },
}
