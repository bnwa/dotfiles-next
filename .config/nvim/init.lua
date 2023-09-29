local appearance = require 'user.utils.appearance'
local plugins = require 'user.plugins'
local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local extend = vim.tbl_extend
local group = vim.api.nvim_create_augroup('Config', { clear = true })
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
opt.timeoutlen = 500
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


--UTILS
local function toggle_night_shift()
  if appearance.is_dark_mode() then
    opt.background = 'dark'
  else
    opt.background = 'light'
  end
end

local function set(modes, lhs, rhs, opts)
  opts = opts and extend('force', { silent = true }, opts) or { silent = true }
  keymap(modes, lhs, rhs, opts)
end

local function on(match, events, listener)
  autocmd(events, {
    callback = listener,
    group = group,
    pattern = match,
  })
end


-- EVENTS
on('*', { 'FocusGained', 'FocusLost' }, toggle_night_shift)
on('*', { 'TermOpen' }, function()
  vim.wo.number = false
  vim.wo.relativenumber = false
end)


-- PLUGINS
plugins.initalize()
plugins.setup()


-- KEYMAPS
set('n', 'j', 'gj') -- down/up treats wrapped lines as single lines
set('n', 'k', 'gk')
set('n', 'p', ']p') -- putting text should match destination indent
set('n', 'P', ']P')
set('n', '<C-J>', '<C-W><C-J>') -- use one chord to switch pane focus
set('n', '<C-K>', '<C-W><C-K>')
set('n', '<C-L>', '<C-W><C-L>')
set('n', '<C-H>', '<C-W><C-H>')


-- COLORS
cmd.colorscheme 'rose-pine'
toggle_night_shift()


-- NEOVIDE
if vim.g.neovide then
  opt.guifont = { 'FiraCode Nerd Font:h16',  }
  vim.g.neovide_remember_window_size = true
  cmd.colorscheme 'rose-pine'
  cmd.cd '~'
end
