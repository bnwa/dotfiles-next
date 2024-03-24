return {
  'williamboman/mason.nvim',
  config = function()
    local mason = require 'mason'
    local registry = require 'mason-registry'

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
  end
}
