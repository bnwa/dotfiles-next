-- Bootstrap lazy.nvim
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.api.nvim_echo({ {"Installing lazy.nvim"} }, true, {})
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath) -- Init lazy.nvim package manager

-- Setup lazy.nvim
require("lazy").setup({
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
  install = {
    missing = true,
  },
  spec = {
    { import = 'config.settings' },
    { import = 'config.plugins.utils' },
    { import = 'config.plugins.tooling' },
    { import = 'config.plugins.parsing' },
    { import = 'config.plugins.semantics' },
    { import = 'config.plugins.editing' },
    { import = 'config.plugins.ui' },
    { import = 'config.plugins.colorscheme' },
    { import = 'config.plugins.assistance' },
    { import = 'config.filetypes' },
  },
})
