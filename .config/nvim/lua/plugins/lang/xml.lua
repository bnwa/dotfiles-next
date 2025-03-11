---@module 'lazy'
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lemminx = {
          settings = {
            xml = {
              format = {
                enabled = true,
                joinCDATALines = false,
                joinCommentLines = false,
                joinContentLines = false,
                spaceBeforeEmptyCloseTag = false,
                splitAttributes = true,
              },
            },
          },
        },
      },
    },
  },
}
