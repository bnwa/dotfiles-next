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

  local function do_setup()
    local success, result = pcall(function()
      if type(setup) == 'function' then
        return setup(config)
      end
      return true
    end)

    if not success then
      vim.notify('LSP setup failed for ' .. server_name .. ': ' .. tostring(result), vim.log.levels.WARN)
      -- Retry after a short delay to allow plugins to load
      vim.defer_fn(function()
        local retry_success, retry_result = pcall(function()
          if type(setup) == 'function' then
            return setup(config)
          end
          return true
        end)

        if retry_success and retry_result then
          vim.lsp.config(server_name, config)
          vim.lsp.enable(server_name)
        else
          vim.notify('LSP setup retry failed for ' .. server_name .. ': ' .. tostring(retry_result), vim.log.levels.ERROR)
        end
      end, 100)  -- 100ms delay
      return
    end

    if result then
      vim.lsp.config(server_name, config)
      vim.lsp.enable(server_name)
    end
  end

  -- Schedule setup to allow lazy-loaded plugins to initialize
  vim.schedule(do_setup)
end

function M.get_clients(buf)
  return vim.lsp.get_clients { bufnr = buf }
end

return M
