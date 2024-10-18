local settings = require 'user.settings.lsp.lua'
local list = require 'user.utils.list'

local ft = {'lua'}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/lazydev.nvim',
    },
    opts = {
      servers = {
        lua_ls = {
          filetypes = ft,
          settings = settings,
          setup = function(config)
            local lsp = require 'lspconfig'
            local lazydev = require 'lazydev'
            local library = vim.api.nvim_get_runtime_file('lua', true)
            local path = vim.split(package.path, ';')
            table.insert(path, 1, 'lua/?/init.lua')
            table.insert(path, 1, 'lua/?.lua')
            local lsp_cfg = vim.tbl_extend('force', {},
              config,
              { settings = { Lua = { workspace = { library = library } } } },
              { settings = { Lua = { runtime = { path = path } } } })
            lazydev.setup {}
            lsp['lua_ls'].setup(lsp_cfg)
          end
        },
      },
    }
  },
  {
    'folke/lazydev.nvim',
    dependencies = {
      'Bilal2453/luvit-meta',
    },
    config = false,
  },
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0,
      })
      return opts
    end,
  },
}
