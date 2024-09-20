return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    'echasnovski/mini.icons' ,
  },
  opts = {
    attach_navic = false,
    exclude_filetypes = {
      'netrw',
      'toggleterm',
    }
  },
}
