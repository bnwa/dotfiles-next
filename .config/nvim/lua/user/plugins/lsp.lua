local lsp_opts = require 'user.settings.lsp'
local autocmd = require 'user.utils.autocmd'

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/SchemaStore.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local opts = lsp_opts
      local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      local installer = require 'mason-tool-installer'
      local mason_lsp = require 'mason-lspconfig'
      local servers = opts.servers
      local ensure_installed = vim.tbl_keys(servers)
      local capabilities = vim.tbl_deep_extend('force',
      {},
      opts.capabilities,
      cmp_ok and cmp_lsp.default_capabilities() or {})

      installer.setup {
        auto_update = true,
        ensure_installed,
      }

      vim.diagnostic.config(opts.diagnostic)

      local function on_attach(client, buf)
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
      end

      local function setup(server_name) 
        local lsp = require 'lspconfig'
        local config = servers[server_name]
        config.on_attach = on_attach
        config.capabilities = capabilities
        lsp[server_name].setup(config)
      end

      mason_lsp.setup {
        handlers = { setup },
      }
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opt = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
      ui = {
        border = "double",
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
    end,
  },
  {
    "Zeioth/mason-extra-cmds",
    opts = {},
  },
  {
    'folke/lazydev.nvim',
    dependencies = {
      'Bilal2453/luvit-meta',
    },
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { "vim%.uv" } },
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "mtoohey31/cmp-fish", ft = "fish" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "ray-x/cmp-treesitter" },
      { "dmitmel/cmp-cmdline-history" },
      { url = "https://codeberg.org/FelipeLema/cmp-async-path" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    opts = function()
      local cmp = require 'cmp'
      return {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
        }, {
          { name = "treesitter" },
        }, {
          { name = "buffer" },
        }),
        view =  {
          docs = {
            auto_open = true,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
    end,
    config = function(_, opts)
      require('cmp').setup(opts)
    end,
  },
}
