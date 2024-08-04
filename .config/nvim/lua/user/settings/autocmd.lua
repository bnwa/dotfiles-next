local autocmd = require 'user.utils.autocmd'
local color = require 'user.utils.color'

local opt = vim.opt

if not vim.g.neovide then
  autocmd.event("Toggle background when focus changes",
  { 'FocusGained', 'FocusLost' },
  { '*' },
  function()
    color.light_or_dark_mode()
  end)
end

autocmd.event("Hightlight matches when searching",
  { 'CmdLineEnter' },
  { [[/,\?]] },
  function() opt.hlsearch = true end)

autocmd.event("Cease highlighting matches when search completes",
  { 'CmdLineLeave' },
  { [[/,\?]] },
  function() opt.hlsearch = false end)

autocmd.event("Auto-create parent directories on :write",
  { 'BufWritePre', 'FileWritePre' },
  { '*' },
  function(evt)
    if evt.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(evt.match) or evt.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end)

autocmd.event("Disable window gutters when terminal active",
  { 'TermOpen' },
  { '*' },
  function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end)

autocmd.event("Resize splits when neovim itself resizes",
  { 'VimResized' },
  nil,
  function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end)

--[[
autocmd.event("Highlight on yank",
 { 'TextYankPost' },
 { '*' },
 function()
   vim.highlight.on_yank()
 end)
]]--

autocmd.event("Close matching filetypes with 'q'",
  { 'FileType' },
  {
    "qf",
    "help",
    "notify",
    "lspinfo",
    "checkhealth",
  },
  function(evt)
    local buf = evt.buf
    vim.bo[buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = buf,
      silent = true })
  end)

autocmd.event("Minimize vim ops when handling bigfiles",
  { 'FileType' },
  { 'bigfile' },
  function(evt)
    local buf = evt.buf
    vim.schedule(function()
      vim.bo[buf].syntax = vim.filetype.match({ buf = buf }) or ""
    end)
  end)

autocmd.event("Keep quickfix buffers unlisted",
  { 'FileType' },
  { 'qf' },
  function()
    vim.opt_local.buflisted = false
  end)
