local settings = require 'user.settings.lsp.lua'
local list = require 'user.utils.list'

local ft = {'lua'}

return {
  {
    'neovim/nvim-lspconfig',
    ft = ft,
    opts = {
      servers = {
        lua_ls = {
          filetypes = ft,
          settings = settings,
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
      library = list.concat({
        { path = 'luvit-meta/library', word = { 'vim%.uv' } }
      },
      list.map(vim.api.nvim_get_runtime_file("", true), function(path)
        return { path = path }
      end)),
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
  },
}
