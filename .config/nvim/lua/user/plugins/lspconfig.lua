local autocmd = require 'user.utils.autocmd'
local severity = vim.diagnostic.severity

local SIGNS = {
  [severity.ERROR] = '',
  [severity.WARN] = '',
  [severity.INFO] = '󰋽',
  [severity.HINT] = '',
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/nvim-cmp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  opts = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    diagnostic = {
      float = {
        border = 'rounded',
        source = 'always',
      },
      jump = {
        float = true,
      },
      severity_sort = true,
      signs = {
        text = SIGNS,
      },
      underline = false,
      update_in_insert = true,
      virtual_text = true,
    },
  },
  config = function(_, opts)
    local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
    local mason_lsp = require 'mason-lspconfig'
    local mason = require 'mason'
    local servers = opts.servers
    local ensure_installed = vim.tbl_keys(servers)
    local capabilities = vim.tbl_deep_extend('force', {}, opts.capabilities, cmp_ok and cmp_lsp.default_capabilities() or {})

    vim.diagnostic.config(opts.diagnostic)

    local function on_attach(client, buf)
      local wk = require 'which-key'

      if client.supports_method('textDocument/inlayHint', { bufnr = buf })
        and vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buftype == '' then
        vim.lsp.inlay_hint.enable(true, { bufnr = buf })
      end
      if client.supports_method('textDocument/codeLens', { bufnr = buf })
        and vim.api.nvim_buf_is_valid(buf)
        and vim.bo[buf].buftype == '' then
        vim.lsp.codelens.refresh()
        autocmd.buffer("Refresh code lens", buf,
        { 'BufEnter', 'CursorHold', 'InsertLeave' },
        function()
          vim.lsp.codelens.refresh()
        end)
      end
      if client.server_capabilities['documentSymbolProvider'] then
        require('nvim-navic').attach(client, buf)
      end
      wk.add({
        '<Tab>',
        function()
          if vim.snippet.active({ direction = 1 }) then
            return '<cmd>lua vim.snippet.jump(1)<cr>'
          else
            return '<Tab>'
          end
        end,
        expr = true,
        buffer = buf,
        mode = { 'i', 's' },
      })
    end

    local function setup(server_name)
      local lsp = require 'lspconfig'
      local config = servers[server_name]

      local local_on_attach = config.on_attach
      local server_config = vim.tbl_extend('force',
      {},
      config, {
        capabilities = capabilities,
        on_attach = function(client, buf)
          local override = false
          if type(local_on_attach) == 'function' then
            override = local_on_attach(client, buf)
          end
          if not override then on_attach(client, buf) end
        end,
      })

      if type(config.setup) == 'function' then
        config.setup(server_config)
      else
        lsp[server_name].setup(server_config)
      end
    end

    mason.setup {
      registries = {
        'github:nvim-java/mason-registry',
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
    mason_lsp.setup {
      automatic_installation = false,
      ensure_installed = ensure_installed,
    }
    mason_lsp.setup_handlers { setup }
  end,
}
