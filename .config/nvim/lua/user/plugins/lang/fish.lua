local ft = {
  'fish'
}

return {
  'neovim/nvim-lspconfig',
  opts = {
    servers = {
     fish_lsp = {
       default_config = {
         cmd = { 'fish-language-server' },
         filetypes = { 'fish' },
         root_dir = function()
           return vim.fs.root(0, { 'config.fish' })
         end,
         settings = {},
      }
     },
    }
  }
}
