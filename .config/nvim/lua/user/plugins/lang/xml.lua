local LSP = require 'user.constants.lsp'
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lemminx = {
          settings = {
            xml = {
              trace = {
                server = 'verbose'
              },
              catalogs = {},
              logs = {
                client = true,
                file = LSP.LOG_PATH
              },
              format = {
                enabled = true,
                joinCDATALines = false,
                joinCommentLines = false,
                joinContentLines = false,
                spaceBeforeEmptyCloseTag = false,
                splitAttributes = true,
              }
            }
          }
        }
      }
    }
  }
}
