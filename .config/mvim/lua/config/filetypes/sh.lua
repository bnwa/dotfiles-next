---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.filetype.sh',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'
      autocmd.filetype({'sh'}, function()
        vim.bo.ts = 4
        vim.bo.sw = 4
      end)
    end
  },
}
