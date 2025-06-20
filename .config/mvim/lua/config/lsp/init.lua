local tbl = require 'config.utils.tbl'

local M = {}

M.diagnostics = {
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
}

function M.match(file_ext)
  if file_ext == 'lua' then
    return { 'lua_ls' }
  end
  return nil
end

function M.on_attach(client, buf)
  local supports_inlay_hints =
  client.supports_method('textDocument/inlayHint', { bufnr = buf })
  and vim.api.nvim_buf_is_valid(buf)
  and vim.bo[buf].buftype == ''

  local supports_code_lens =
  client.supports_method('textDocument/codeLens', { bufnr = buf })
  and vim.api.nvim_buf_is_valid(buf)
  and vim.bo[buf].buftype == ''

  if supports_code_lens then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      buffer = buf,
      callback = vim.lsp.codelens.refresh,
    })
  end

  if supports_inlay_hints then
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end

  vim.diagnostic.config(M.diagnostics)
  vim.diagnostic.enable(true, { bufnr = buf })

  M.attach_keymaps(client, buf)
end

function M.setup(server_name, server_config)
  local lsp = require 'lspconfig'
  local cmp = require 'blink.cmp'

  --local on_attach = server_config.on_attach
  local capabilities = vim.tbl_deep_extend('force', {},
    vim.lsp.protocol.make_client_capabilities(),
    server_config.capabilities or {})
  local setup, config = tbl.destruct(vim.tbl_extend('force', {},
    server_config,
    { capabilities = cmp.get_lsp_capabilities(capabilities) },
    {
      workspace = {
        fileOperations = {
          willCreate = true,
          didCreate = true,
          willRename = true,
          didRename = true,
          willDelete = true,
          didDelete = true,
        },
      },
    }), {'setup'})

  if type(setup) ~= 'function' or setup(config) then
    vim.lsp.config(server_name, config)
    vim.lsp.enable(server_name)
  end
end

function M.attach_keymaps(_, buf)
  local fzf = require 'fzf-lua'
  local keymaps = {
    { '<leader>ca',  vim.lsp.buf.code_action, { buffer = buf, desc = "Select code action on cursor or range" }},
    { '<leader>cc',  vim.lsp.codelens.run, { buffer = buf, desc = "Execute codelens on cursor" }},
    { '<leader>cC',  vim.lsp.codelens.refresh, { buffer = buf, desc = "Refresh codelens on cursor" }},
    { '<leader>cr',  vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol at cursor" }},
    { '<leader>gd',  vim.lsp.buf.definition, { buffer = buf, desc = "Jump to declaration of the symbol under the cursor" } },
    { '<leader>sr',  fzf.lsp_references, { buffer = buf, desc = "List all the references for the symbol under the cursor" } },
    { '<leader>sS',  fzf.lsp_workspace_symbols, { buffer = buf, desc = 'List all symbols in the workspace' } },
    { '<leader>si',  fzf.lsp_implementations, { buffer = buf, desc = "List all implementations for the symbol under the cursor" } },
    { '<leader>shk', fzf.lsp_incoming_calls, { buffer = buf, desc = 'List all call sites for the symbol under the cursor' } },
    { '<leader>shj', fzf.lsp_outgoing_calls, { buffer = buf, desc = 'List all call sites for the symbol under the cursor' } },
    { '<leader>xx',  function() fzf.lsp_document_diagnostics {
        ['winopts.preview.layout'] = 'vertical',
        ['winopts.width'] = 1,
      } end, {
        buffer = buf,
        desc = "List all diagnostics in the current buffer"
      }
    },
    { '<leader>xX',  function() fzf.lsp_workspace_diagnostics {
        ['winopts.preview.layout'] = 'vertical',
        ['winopts.width'] = 1,
      } end, {
        buffer = buf,
        desc = "List all diagnostics in the current workspace"
      }
    },
  }
  for _, keymap in ipairs(keymaps) do
    local opts = keymap[3]
    vim.keymap.set(opts.mode or 'n', keymap[1], keymap[2], opts)
  end
end

function M.get_clients(buf)
  return vim.lsp.get_clients { bufnr = buf }
end

return M
