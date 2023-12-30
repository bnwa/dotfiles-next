return {
  'williamboman/mason.nvim',
  config = function()
    local mason = require 'mason'
    local registry = require 'mason-registry'
    local ensure_installed = {
      'jdtls',
      'json-lsp',
      'lemminx',
      'lua-language-server',
      'typescript-language-server',
    }

    mason.setup {
      PATH = 'prepend',
      ui = {
        border = 'shadow',
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        }
      }
    }

    -- Install servers that're ensured and reload ftplugin
    -- if no LSP client attached to current buffer
    for _, server in ipairs(ensure_installed) do
      if not registry.is_installed(server) then
        vim.cmd { cmd = 'MasonInstall' , args = { server } }
      end
    end

    if #vim.lsp.get_active_clients({ buffer = 0 }) == 0 then
      vim.cmd { cmd = 'filetype', args = { 'detect' } }
    end
  end
}
