---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
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

          if type(server_on_attach) ~= "function" or server_on_attach(client, buf) then
            lsp.on_attach(client, buf)
          end
        end
      })
      for server_name, server_config in pairs(opts.servers) do
        lsp.setup(server_name, server_config)
      end
    end
  },
  {
    'user.keymap.lsp',
    virtual = true,
    dependencies = {
      'neovim/nvim-lspconfig',
      'folke/which-key.nvim',
      'folke/snacks.nvim',
    },
    ---@module 'which-key.config'
    ---@type wk.Spec
    opts = function (_, opts)
      return vim.tbl_deep_extend('force', opts, {
        {
          '<leader>aa',
          vim.lsp.buf.code_action,
          desc = "List and select from LSP-provided code actions for the symbol under the cursor",
        },
        {
          '<leader>ae',
          vim.lsp.codelens.run,
          desc = "Execute LSP-provided code lens for the current line",
        },
        {
          '<leader>ar',
          vim.lsp.buf.rename,
          desc = "Rename symbol at cursor via LSP",
        },
        {
          '<leader>slc',
          vim.lsp.buf.incoming_calls,
          desc = "List and select from call sites for the symbol under the cursor",
        },
        {
          '<leader>slC',
          vim.lsp.buf.outgoing_calls,
          desc = "List and select from symbols called from the symbol under the cursor",
        },
        {
          '<leader>sld',
          function() Snacks.picker.lsp_type_definitions {} end,
          desc = "List and select from type definitions for the symbol under the cursor",
        },
        {
          '<leader>slD',
          function() Snacks.picker.lsp_implementations {} end,
          desc = "List and select from type implementations for the symbol under the cursor",
        },
        {
          '<leader>slr',
          function() Snacks.picker.lsp_references {} end,
          desc = "List all the references for the symbol under the cursor",
        },
        { '<leader>sls',
          function() Snacks.picker.lsp_symbols() end,
          desc = "Search symbols in the current buffer via LSP",
        },
        {
          '<leader>slS',
          function() Snacks.picker.lsp_workspace_symbols {} end,
          desc = 'Search symbols in the workspace via LSP',
        },
        {
          '<leader>xx',
          function() Snacks.picker.diagnostics {} end,
          desc =  "List all diagnostics in the current workspace",
        },
        {
          '<leader>xX',
          function() Snacks.picker.diagnostics_buffer {} end,
          desc = "List all diagnostics in the current buffer",
        },
      })
    end
  }
}
