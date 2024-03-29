local appearance = require 'user.utils.appearance'
local autocmd = require 'user.utils.autocmd'
local keymaps = require 'user.utils.keymaps'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local nmap = keymaps.nmap
local cmd = vim.cmd
local opt = vim.opt


-- OPTIONS
opt.background = 'dark'
opt.expandtab = true
opt.gdefault = true
opt.laststatus = 3
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
if not vim.g.neovide then
  autocmd.on('*', { 'FocusGained', 'FocusLost' },
    appearance.toggle_light_dark_mode)
end

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
if not vim.g.neovide then
  appearance.toggle_light_dark_mode()
end
cmd.colorscheme 'melange'


-- NEOVIDE
if vim.g.neovide then
  vim.g.neovide_theme = 'auto' -- Neovide will manage light/dark mode
  vim.g.neovide_remember_window_size = true
  cmd.cd '~'
end
