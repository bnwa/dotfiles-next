local autocmd = require 'user.utils.autocmd'
local ft = vim.filetype

ft.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile.size
            and "bigfile"
          or nil
      end,
    },
  },
})

autocmd.filetype({'html', 'java', 'markdown', 'sql', 'xml' }, function(evt)
  vim.bo[evt.buf].shiftwidth = 4
  vim.bo[evt.buf].tabstop = 4
end)

