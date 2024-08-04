local autocmd = require 'user.utils.autocmd'

autocmd.filetype({'html', 'java', 'markdown', 'sql', 'xml' }, function(evt)
  vim.bo[evt.buf].shiftwidth = 4
  vim.bo[evt.buf].softtabstop = 4
end)

