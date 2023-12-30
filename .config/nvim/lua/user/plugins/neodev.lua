return {
  'folke/neodev.nvim',
  config = function()
    require('neodev').setup {
      lspconfig = false,
      setup_jsonls = false,
    }
  end
}
