local lsp_util = require 'user.utils.lsp'
local lsp_opts = require 'user.settings.lsp'
local autocmd = require 'user.utils.autocmd'


return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/SchemaStore.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'yioneko/nvim-vtsls',
    },
    config = function()
      local opts = lsp_opts
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
              vim.print('Should jump')
              return '<cmd>lua vim.snippet.jump(1)<cr>'
            else
              vim.print('Did not jump')
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
        config.on_attach = on_attach
        config.capabilities = capabilities
        if server_name == 'vtsls' then
          require('lspconfig.configs').vtsls = require('vtsls').lspconfig
        end
        lsp[server_name].setup(config)
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
      library = vim.list_extend({
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { "vim%.uv" } },
      }, vim.tbl_map(function(path) return { path, word = { 'vim' } } end,
      vim.api.nvim_get_runtime_file("", true)))
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp" ,
      "hrsh7th/cmp-buffer" ,
      "hrsh7th/cmp-cmdline" ,
      "hrsh7th/cmp-nvim-lsp-document-symbol" ,
      "hrsh7th/cmp-nvim-lsp-signature-help" ,
      "ray-x/cmp-treesitter" ,
      "dmitmel/cmp-cmdline-history" ,
      { "mtoohey31/cmp-fish", ft = "fish" },
      { url = "https://codeberg.org/FelipeLema/cmp-async-path" },
    },
    opts = function()
      local cmp = require 'cmp'
      local defaults = require('cmp.config.default')()
      return {
        formatting = {
          format = require('lspkind').cmp_format({
            ellipsis_char = '…',
            maxwidth = function()
              return math.floor(0.45 * vim.o.columns)
            end,
            mode = 'symbol',
            show_labelDetails = true,
          })
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-CR>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "lazydev" },
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
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
      menu = {},
    },
    enabled = vim.g.icons_enabled,
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },
}
