return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        cssls = {
          settings = {
            css = {
              completion = true,
              hover = true,
              importAliases = true,
              lint = true,
              validate = true,
            },
            scss = {
              completion = true,
              hover = true,
              importAliases = true,
              lint = true,
              validate = true,
            },
            less = {
              completion = true,
              hover = true,
              importAliases = true,
              lint = true,
              validate = true,
            },

          }
        }
      }
    },
  },
}
