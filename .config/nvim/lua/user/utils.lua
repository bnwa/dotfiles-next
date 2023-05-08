local M = {}
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local loop = vim.loop

-- GUI interface even better for spec'ing dest
function M.lspRenameFile(client, src, dest)
  local srcId = fn.bufadd(src)
  local destExists = fn.filereadable(dest) == 1
  local lspCmd = 'workspace/executeCommand'
  local lspCmdParams = {
    command = '_typescript.applyRenameFile',
    arguments = {
      {
        sourceUri = vim.uri_from_fname(src),
        targetUri = vim.uri_from_fname(dest),
      },
    },
  }

  if not destExists then
    if fn.confirm("Expected file path to rename to exists, overwrite", "&Yes\n&No", 2, 'Warning') ~= 1 then
      print 'Rename aborted'
      return
    end
  end

  fn.mkdir(fn.fnamemodify(dest, ":p:h"), "p")
  local req_ok = client.request(lspCmd, lspCmdParams)

  if not req_ok then
    print 'Encountered error renaming file'
    return
  end

  if api.nvim_buf_get_option(srcId, 'modified') then
    api.nvim_buf_call(srcId, function() cmd 'w!' end)
  end

  local rename_ok, rename_err = loop.fs_rename(src, dest)
  if not rename_ok then
    print('Encountered error renaming file: ' .. rename_err)
    return
  end

  local targetId = fn.bufadd(dest)
  api.nvim_buf_set_option(targetId, 'buflisted', true)
  for _, win in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_get_buf(win) == srcId then
      api.nvim_win_set_buf(win, targetId)
    end
  end

  vim.schedule(function()
    api.nvim_buf_delete(srcId, { force = true })
  end)
end

return M
