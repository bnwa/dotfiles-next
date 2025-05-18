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
                file = vim.fn.stdpath('state') .. 'lsp.log'
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
