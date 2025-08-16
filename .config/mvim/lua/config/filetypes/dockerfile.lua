---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.dockerfile',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'
      autocmd.filetype({'dockerfile'}, function()
        vim.bo.ts = 4
        vim.bo.sw = 4
      end)
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {
        'docker_language_server',
      },
    },
  },
}
