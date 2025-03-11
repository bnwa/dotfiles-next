---@module 'lazy'
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              completion = true,
              hover = true,
            },
          },
        },
      },
    },
  },
}
