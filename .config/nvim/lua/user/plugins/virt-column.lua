--- @module 'lazy.types'
--- @type LazySpec
return {
  "lukas-reineke/virt-column.nvim",
  config = function()
    require("virt-column").setup({ char = "▕" })
  end,
}
