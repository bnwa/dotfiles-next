local server_config = require 'user.settings.lsp.lua'

local ft = {'lua'}

return {
  {
    'neovim/nvim-lspconfig',
    ft = ft,
    opts = {
      servers = {
        lua_ls = {
          filetypes = ft,
          server_config = server_config,
        },
      },
    }
  },
  {
    'folke/lazydev.nvim',
    dependencies = {
      'Bilal2453/luvit-meta',
      'neovim/nvim-lspconfig'
    },
    ft = ft,
    opts = {
      library = vim.list_extend({
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { "vim%.uv" } },
      }, vim.tbl_map(function(path) return { path, word = { 'vim' } } end,
      vim.api.nvim_get_runtime_file("", true)))
    },
  },
}
