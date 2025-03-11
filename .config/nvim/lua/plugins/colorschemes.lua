require("lazy.types")

---@param specs  LazyPluginSpec[]
---@return LazyPluginSpec[]
local function colorschemes(specs)
  local function merge_defaults(spec)
    return vim.tbl_extend("force", { event = "VeryLazy" }, spec)
  end
  return vim.tbl_map(merge_defaults, specs)
end

return colorschemes({
  {
    "savq/melange",
  },
  {
    "ramojus/mellifluous.nvim",
    version = "*",
    opts = {},
  },
})
