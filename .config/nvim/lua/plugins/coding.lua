---@type string[]
local disabled_filetypes = {
  "copilot-chat",
  "snacks_picker_input",
  "AvanteInput",
  "AvanteSelectedFiles",
  "Avante",
}

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'saghen/blink.cmp',
    ---@module 'blink.cmp'
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      local list = require 'user.utils.list'
      local sources = opts.sources.default
      if (type(sources) == 'table') then
        list.remove(sources, 'buffer')
      end
      return vim.tbl_deep_extend('force', opts, {
        enabled = function()
          return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
        end
      })
    end
  }
}
