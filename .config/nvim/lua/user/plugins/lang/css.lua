local settings = require 'user.settings.lsp.css'

local ft = {
  'css',
  'scss',
  'less',
}

--- @module 'lazy.types'
--- @type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        cssls = {
          filetypes = ft,
          settings = settings,
        },
      },
    },
  },
}
