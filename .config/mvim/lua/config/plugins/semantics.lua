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
      'ibhagwan/fzf-lua',
    },
    event = 'LspAttach',
    ---@module 'which-key.config'
    ---@type wk.Spec
    opts = function (_, opts)
      local fzf = require 'fzf-lua'
      return vim.tbl_deep_extend('force', opts, {
        {
          '<leader>ce',
          vim.lsp.codelens.run,
          buffer = true,
          desc = "Execute code lens on current line",
        },
        {
          '<leader>cr',
          vim.lsp.buf.rename,
          buffer = true,
          desc = "Rename symbol at cursor",
        },
        {
          '<leader>cc',
          fzf.lsp_code_actions,
          buffer = true,
          desc = "Select an LSP code action for the symbol under the cursor",
        },
        {
          '<leader>scc',
          fzf.lsp_incoming_calls,
          buffer = true,
          desc = "Search for all call sites for symbol under cursor",
        },
        {
          '<leader>scC',
          fzf.lsp_outgoing_calls,
          buffer = true,
          desc = "Search for all call sites for symbol under cursor",
        },
        {
          '<leader>scd',
          fzf.lsp_definitions,
          buffer = true,
          desc = "Jump to declaration of the symbol under the cursor"
        },
        {
          '<leader>scr',
          fzf.lsp_references,
          buffer = true,
          desc = "List all the references for the symbol under the cursor",
        },
        {
          '<leader>scm',
          fzf.lsp_implementations,
          buffer = true,
          desc = "List all implementations for the symbol under the cursor"
        },
        {
          '<leader>ss',
          fzf.lsp_document_symbols,
          buffer = true,
          desc = "Search symbols in the current buffer via LSP",
        },
        {
          '<leader>sS',
          fzf.lsp_workspace_symbols,
          buffer = true,
          desc = 'Search all symbols in the workspace'
        },
        {
          '<leader>xx',
          function()
            fzf.lsp_document_diagnostics {
              ['winopts.preview.layout'] = 'vertical',
              ['winopts.width'] = 1,
            }
          end,
          buffer = true,
          desc = "List all diagnostics in the current buffer",
        },
        {
          '<leader>xX',
          function()
            fzf.lsp_workspace_diagnostics {
              ['winopts.preview.layout'] = 'vertical',
              ['winopts.width'] = 1,
            }
          end,
          buffer = true,
          desc = "List all diagnostics in the current workspace"
        },
      })
    end,
    config = function(_, opts)
      local wk = require 'which-key'
      for _, map in ipairs(opts) do
        wk.add(map)
      end
    end
  }
}
