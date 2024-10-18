local settings = require 'user.settings.lsp.css'

local ft = {
  'css',
  'scss',
  'less',
}

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
