local list = require 'user.utils.list'
local path = require 'user.utils.path'
local platform = require 'user.utils.platform'

local fn = vim.fn
local err = vim.api.nvim_err_writeln
local notify = vim.notify

local function run(cmd)
  return vim.system(cmd):wait()
end

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
  local lazypath_setup = run({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    LAZY_PATH,
  })
  if lazypath_setup.code ~= 0 then
    return err("Error cloning lazy.nvim repository, plugin setup will " .. "terminate:\n\n" .. lazypath_setup.stderr)
  end
end

if should_update_brew then
  if path.can_exec 'brew' then
    err("Certain path binary dependencies missing, installing...")
    local brew_update = run({ 'brew', 'update' })
    if brew_update.code == 0 then
      local missing = {}
      if not has_rg then list.append(missing, 'ripgrep') end
      if not has_fd then list.append(missing, 'fd') end
      if not has_fzf then list.append(missing, 'fzf') end
      if not has_make then list.append(missing, 'make') end
      if not has_cmake then list.append(missing, 'cmake') end
      local brew_install = run(list.concat({ 'brew', 'install' }, missing))
      if brew_install.code ~= 0 then
        err("Homebrew failed to install missing plugin path dependencies: " ..  missing .. "\n\n" .. brew_install.stderr)
      end
    else
      err("Encountered error updating brew, certain plugin behavior " ..  "will be missing:\n\n" .. brew_update.stderr)
    end
  else
    err("Missing binary plugin deps but Homebrew not installed, " ..  "certain behavior may be missing")
  end
end

vim.opt.rtp:prepend(LAZY_PATH)
require('lazy').setup 'user.plugins'
