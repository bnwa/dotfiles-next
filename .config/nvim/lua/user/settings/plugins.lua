local list = require 'user.utils.list'
local path = require 'user.utils.path'
local platform = require 'user.utils.platform'

local notify = vim.notify
local fn = vim.fn

local LAZY_PATH = fn.stdpath('data') .. '/lazy/lazy.nvim'

local has_rg = path.can_exec 'rg'
local has_fd = path.can_exec 'fd'
local has_fzf = path.can_exec 'fzf'
local has_make = path.can_exec 'make'
local has_cmake = path.can_exec 'cmake'

local should_update_brew = platform.os.mac and
  not has_rg or
  not has_fd or
  not has_fzf or
  not has_make and not has_cmake

if not vim.uv.fs_stat(LAZY_PATH) then
  notify "Lazy.nvim package manager not found, installing..."
  local installed_lazy = platform.exec({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    LAZY_PATH,
  })
  if not installed_lazy then
    return notify "Error cloning lazy.nvim repository, plugin setup will terminate"
  end
end

if should_update_brew then
  local missing = {}
  if not path.can_exec 'brew' then
    return notify "Missing binary plugin deps but Homebrew not installed, " ..  "certain behavior may be missing"
  end

  notify "Certain path binary dependencies missing, installing..."

  local brew_update = platform.exec({ 'brew', 'update' })
  if not brew_update then
    return notify "Encountered error updating brew, certain plugin behavior will be missing"
  end

  if not has_rg then list.append(missing, 'ripgrep') end
  if not has_fd then list.append(missing, 'fd') end
  if not has_fzf then list.append(missing, 'fzf') end
  if not has_make then list.append(missing, 'make') end
  if not has_cmake then list.append(missing, 'cmake') end

  local brew_install = platform.exec(list.concat({ 'brew', 'install' }, missing))
  if not brew_install then
    return notify "Homebrew failed to install missing plugin path dependencies:" .. fn.join(missing, ', ')
  end
end

vim.opt.rtp:prepend(LAZY_PATH)
require('lazy').setup {
  { import = 'user.plugins.lang' },
  { import = 'user.plugins' },
}
