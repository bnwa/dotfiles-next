---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
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
      local cmp = require 'blink.cmp'
      local lsp = require 'config.lsp'

      for server_name, server_config in pairs(opts.servers) do
        local server_setup = server_config.setup
        local server_on_attach = server_config.on_attach
        local server_capabilities = server_config.capabilities or {}
        local has_own_setup = type(server_setup) == 'function'

        if not has_own_setup or server_setup(server_config) then
          local config = vim.tbl_extend('force',
            server_config,
            { capabilities = nil, on_attach = nil, setup = nil },
            { capabilities = cmp.get_lsp_capabilities(server_capabilities, true) },
            { on_attach = lsp.on_attach(server_on_attach) })

          vim.lsp.config(server_name, config)
          vim.lsp.enable(server_name)
        end

        server_config.setup = nil
        server_config.on_attach = nil

        local config = vim.tbl_extend('force',
          server_config,
          { capabilities = cmp.get_lsp_capabilities(server_capabilities, true) },
          { on_attach = lsp.on_attach(server_on_attach) })

        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
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
    opts = function (_, opts)
      ---@module 'which-key.config'
      ---@type wk.Spec
      return vim.tbl_deep_extend('force', opts, {
        {
          '<leader>al',
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
