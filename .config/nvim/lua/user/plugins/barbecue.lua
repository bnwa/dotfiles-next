return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    'echasnovski/mini.icons' ,
  },
  opts = {
    exclude_filetypes = {
      'netrw',
      'toggleterm',
    }
  },
}
