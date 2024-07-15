local color = require 'user.utils.color'
local path = require 'user.utils.path'

local augroup = vim.api.nvim_create_augroup
local opt = vim.opt
local fn = vim.fn

local USER_AUGROUP = augroup('User', { clear = true })

local function autocmd_once(desc, matches, evts, listener)
  autocmd(evts, {
    callback = listener,
    desc = desc,
    group = USER_AUGROUP,
    once = true,
    pattern = matches,
  })
end

local function autocmd(desc, matches, evts, listener)
  vim.api.nvim_create_autocmd(evts, {
    callback = listener,
    desc = desc,
    group = USER_AUGROUP,
    pattern = matches,
  })
end

if not vim.g.neovide then
  autocmd("Toggle background when focus changes",
  { '*' },
  { 'FocusGained', 'FocusLost' },
  function()
    color.light_or_dark_mode()
  end)
end

autocmd("Set indent to 4 spaces for specific filetypes",
  {
    '*.html',
    '*.java',
    '*.markdown',
    '*.sql',
    '*.xml',
  },
  { 'FileType' },
  function()
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end)

autocmd("Hightlight matches when searching",
  { [[/,\?]] },
  { 'CmdLineEnter' },
  function() opt.hlsearch = true end)

autocmd("Cease highlighting matches when search completes",
  { [[/,\?]] },
  { 'CmdLineLeave' },
  function() opt.hlsearch = false end)

autocmd("Auto-create parent directories on :write",
  { '*' },
  { 'BufWritePre', 'FileWritePre' },
  function(evt)
    if evt.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(evt.match) or evt.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end)

autocmd("Disable window gutters when terminal active",
  { '*' },
  { 'TermOpen' },
  function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end)

autocmd("Resize splits when neovim itself resizes",
  nil,
  { 'VimResized' },
  function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end)

autocmd("Highlight on yank",
 { '*' },
 { 'TextYankPost' },
 function()
   vim.highlight.on_yank()
 end)

autocmd("Close matching filetypes with 'q'",
  {
    "qf",
    "help",
    "notify",
    "lspinfo",
    "checkhealth",
  },
  { 'FileType' },
  function(evt)
    vim.bo[evt.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = evt.buf,
      silent = true })
  end)

autocmd("Minimize vim ops when handling bigfiles",
  { 'bigfile' },
  { 'FileType' },
  function(evt)
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
    end)
  end)

autocmd("Keep quickfix buffers unlisted",
  { 'qf' },
  { 'FileType' },
  function()
    vim.opt_local.buflisted = false
  end)
