local appearance = require 'user.utils.appearance'
local autocmd = require 'user.utils.autocmd'
local keymaps = require 'user.utils.keymaps'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local nmap = keymaps.nmap
local cmd = vim.cmd
local opt = vim.opt

--[[
TODO Rebind motions/text objects meant for
prose for more appropriate uses in coding
context, see :h object-motions, specifically
sentence/paragraph/section types
--]]


-- OPTIONS
opt.background = 'dark'
opt.expandtab = true
opt.gdefault = true
opt.laststatus = 2
opt.number = true
opt.listchars.precedes = "«"
opt.listchars.extends = "»"
opt.relativenumber = true
if jit.arch == 'x64' then
  opt.shell = "/usr/local/bin/fish -l"
else
  opt.shell = "/opt/homebrew/bin/fish -l"
end
opt.shortmess:append "c"
opt.splitbelow = false
opt.splitright = false
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 1000
opt.wildignore:append '/.git'
opt.wrap = false
opt.writebackup = false
opt.undofile = true
opt.updatetime = 100
opt.visualbell = false

vim.diagnostic.config {
  virtual_text = false,
}

vim.g.mapleader = ' '


-- PLUGINS
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })

  vim.notify 'Plugin manager initialized - restart to use plugins'
else
  vim.opt.rtp:prepend(lazypath)
  require('lazy').setup('user.plugins')
end


-- EVENTS
autocmd.on('*', { 'FocusGained', 'FocusLost' },
  appearance.toggle_light_dark_mode)

autocmd.on('*', { 'TermOpen' }, function()
  vim.wo.number = false
  vim.wo.relativenumber = false
end)


-- KEYMAPS
nmap('j', 'gj') -- down/up treats wrapped lines as single lines
nmap('k', 'gk')
nmap('<C-J>', '<C-W><C-J>') -- use one chord to switch pane focus
nmap('<C-K>', '<C-W><C-K>')
nmap('<C-L>', '<C-W><C-L>')
nmap('<C-H>', '<C-W><C-H>')


-- COLORS
cmd.colorscheme 'rose-pine'
appearance.toggle_light_dark_mode()


-- NEOVIDE
if vim.g.neovide then
  opt.guifont = { 'FiraCode Nerd Font:h16',  }
  vim.g.neovide_remember_window_size = true
  cmd.colorscheme 'rose-pine'
  cmd.cd '~'
end
