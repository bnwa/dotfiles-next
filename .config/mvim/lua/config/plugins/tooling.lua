---@module 'lazy'
---@type LazySpec[]
return {
  {
    'williamboman/mason.nvim',
    version = "1.x",
    build = ':MasonUpdate',
    dependencies = {
      { "Zeioth/mason-extra-cmds", opts = {} },
    },
    ---@module 'mason'
    ---@type MasonSettings
    opts = {
      registries = {
        'github:bnwa/mason-registry',
        'github:mason-org/mason-registry',
      },
      ui = {
        border = 'rounded',
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    }
  },
  {
    'williamboman/mason-lspconfig.nvim',
    version = "1.x",
    dependencies = {
      'williamboman/mason.nvim'
    },
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {},
      automatic_installation = true
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    opts = {
      diagnostics = {
        float = {
          source = 'if_many',
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '',
          },
        },
        underline = false,
        update_in_insert = true,
        virtual_text = false
      },
      servers = {},
    },
    config = function(_, opts)
      local lsp = require 'config.lsp'
      vim.api.nvim_create_autocmd({'LspAttach' }, {
        callback = function(args)
          local buf = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local server_name = client and client.name
          if not server_name then
            return vim.notify('No LSP Client Configured')
          end
          local server_config = opts.servers[server_name]
          if not server_config then
            vim.health.warn('Failed to find LSP params for server "' .. server_name .. '"')
            return
          end
          local server_on_attach = server_config.on_attach
          if server_on_attach ~= nil and server_on_attach(client, buf) then
            lsp.on_attach(client, buf)
          else
            lsp.on_attach(client, buf)
          end
        end
      })
      for server_name, server_config in pairs(opts.servers) do
        lsp.setup(server_name, server_config)
      end
    end
  }
}
