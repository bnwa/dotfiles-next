local autocmd = require 'user.utils.autocmd'

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = function()
      local opts = require 'user.settings.lsp'
      return opts
    end,
    config = function(_, opts)
      local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      local mason_lsp = require 'mason-lspconfig'
      local servers = opts.servers
      local ensure_installed = vim.tbl_keys(servers)
      local capabilities = vim.tbl_deep_extend('force',
      {},
      opts.capabilities,
      cmp_ok and cmp_lsp.default_capabilities() or {})

      vim.diagnostic.config(opts.diagnostic)

      local function on_attach(client, buf)
        local wk = require('which-key')
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

        local server_config = vim.tbl_extend('force', {},
          config.server_config, {
          capabilities = capabilities,
          on_attach = function(client, buf)
            local override = false
            if type(config.on_attach) == 'function' then
              override = config.on_attach(client, buf)
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

      mason_lsp.setup {
        automatic_installation = false,
        ensure_installed = ensure_installed,
        handlers = { setup },
      }
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'Zeioth/mason-extra-cmds',
    },
    config = function()end,
  },
  {
    "Zeioth/mason-extra-cmds",
    dependencies = {
      'williamboman/mason.nvim',
    },
    opts = {},
  },
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    opt = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
      ui = {
        border = 'rounded',
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    config = function(_, opts)
      local mason = require 'mason'
      mason.setup(opts)
    end,
  },
}
