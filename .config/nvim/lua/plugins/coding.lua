---@type string[]
local disabled_filetypes = {
  "copilot-chat",
  "snacks_picker_input",
}

--- @type LazySpec[]
return {
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end
    }
  }
}
