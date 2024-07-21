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
    },
    opts = {
      integrations = {
        lspconfig = true,
        cmp = true,
        coq = false,
      },
      library = {
        { path = 'luvit-meta/library', word = { 'vim%.uv' } },
      },
      runtime = vim.env.VIMRUNTIME,
    },
  },
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0,
        entry_filter = function()
          return vim.bo.filetype == 'lua'
        end
      })
    end,
  }
}
