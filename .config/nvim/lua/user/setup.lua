local platform = require("user.utils.platform")

local has_rg = vim.fn.executable("rg") == 1
local has_fd = vim.fn.executable("fd") == 1
local has_fzf = vim.fn.executable("fzf") == 1
local has_make = vim.fn.executable("make") == 1
local has_cmake = vim.fn.executable("cmake") == 1
local has_brew_node = vim.fn.executable("/opt/homebrew/bin/node") == 1
local has_brew_sqlite = vim.fn.isdirectory("/opt/homebrew/opt/sqlite/lib")

local should_update_brew = platform.os.mac and not has_rg or not has_fd or not has_fzf or not has_make or not has_cmake

if should_update_brew then
  --- @type string[]
  local missing = {}
  if not vim.fn.executable("brew") then
    return vim.notify("Missing binary plugin deps but Homebrew not installed, ") .. "certain behavior may be missing"
  end

  vim.notify("Certain path binary dependencies missing, installing...")

  local brew_update = platform.exec({ "brew", "update" })
  if not brew_update then
    return vim.notify("Encountered error updating brew, certain plugin behavior will be missing")
  end

  if not has_rg then
    table.insert(missing, "ripgrep")
  end
  if not has_fd then
    table.insert(missing, "fd")
  end
  if not has_fzf then
    table.insert(missing, "fzf")
  end
  if not has_make then
    table.insert(missing, "make")
  end
  if not has_cmake then
    table.insert(missing, "cmake")
  end
  if not has_brew_sqlite then
    table.insert(missing, "sqlite")
  end
  if not has_brew_node then
    table.insert(missing, "node")
  end

  local brew_install = platform.exec(vim.list_extend({ "brew", "install" }, missing))
  if not brew_install then
    return vim.notify("Homebrew failed to install missing plugin path dependencies:") .. vim.fn.join(missing, ", ")
  end
end
