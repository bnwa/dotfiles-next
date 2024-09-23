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
      'echasnovski/mini.icons',
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
      --https://github.com/zbirenbaum/copilot-cmp
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
      end
      return {
        formatting = {
          format = function(entry, vim_item)
            local icon = MiniIcons.get('lsp', vim_item.kind)
            vim_item.kind = icon .. ' ' .. vim_item.kind
            return vim_item
          end
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-f>'] = function(fallback)
            if cmp.visible() and cmp.visible_docs then
              cmp.mapping.scroll_docs(4)
            else
              fallback()
            end
          end,
          ['<C-b>'] = function(fallback)
            if cmp.visible() and cmp.visible_docs then
              cmp.mapping.scroll_docs(-4)
            else
              fallback()
            end
          end,
          ['C-o>'] = cmp.mapping.open_docs(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          ['<C-[>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
            else
              return fallback()
            end
          end),
          ["<CR>"] = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
            else
              return fallback()
            end
          end
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = 'cmp_yanky'},
          { name = "treesitter" },
        },{
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
      local autopairs = require 'nvim-autopairs.completion.cmp'
      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = { { name = "dap" } },
      })
      cmp.setup(opts)
      cmp.event:on('confirm_done', autopairs.on_confirm_done())
    end,
  }
}
