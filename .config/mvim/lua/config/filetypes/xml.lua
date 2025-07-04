---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.xml',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'
      autocmd.filetype({'xml'}, function()
        vim.bo.ts = 4
        vim.bo.sw = 4
      end)
    end
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lemminx = {
          filetypes = {
            'xml',
          },
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
