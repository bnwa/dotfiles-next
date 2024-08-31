return {
  {
    "hrsh7th/cmp-cmdline" ,
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
        },{
          { name = 'treesitter' },
        },{
          { name = 'buffer' },
        }),
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline', priority = 1000, option = { ignore_cmds = { 'Man', '!' } } },
          { name = 'cmdline_history', priority = 500 },
          { name = 'path', priority = 750 },
        })
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'rcarriga/cmp-dap',
      'onsails/lspkind.nvim',
      'garymjr/nvim-snippets' ,
      'hrsh7th/cmp-nvim-lsp' ,
      'hrsh7th/cmp-buffer' ,
      'hrsh7th/cmp-nvim-lsp-document-symbol' ,
      'hrsh7th/cmp-nvim-lsp-signature-help' ,
      'ray-x/cmp-treesitter' ,
      'dmitmel/cmp-cmdline-history' ,
      'zbirenbaum/copilot-cmp',
      { 'mtoohey31/cmp-fish', ft = "fish" },
      { url = 'https://codeberg.org/FelipeLema/cmp-async-path' },
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
            symbol_map = { Copilot = '' },
          })
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['C-o>'] = cmp.mapping.open_docs(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-[>'] = function(fallback)
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
          { name = "nvim_lsp" },
          { name = 'cmp_yanky'},
          { name = 'copilot' },
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
          completion = cmp.config.window.bordered({ border = 'rounded' }),
          documentation = cmp.config.window.bordered({ border = 'rounded' }),
        },
      }
    end,
    config = function(_, opts)
      local cmp = require 'cmp'
      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = { { name = "dap" } },
      })
      cmp.setup(opts)

    end,
  }
}
