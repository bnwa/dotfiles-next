local autocmd = require 'user.utils.autocmd'
local platform = require 'user.utils.platform'
local colorscheme = vim.g.colorscheme

local function light_or_dark_mode()
    local ok, is_dark = platform.is_dark_mode()
    if ok and is_dark then
        vim.opt.background = 'dark'
    else
        vim.opt.background = 'light'
    end
end

if vim.g.neovide then
    vim.g.neovide_theme = 'auto' -- Neovide will manage light/dark mode
else
    autocmd.on({ 'FocusGained', 'FocusLost' }, {
        desc = "Toggle background when focus changes",
        callback = light_or_dark_mode,
    })
end

if not pcall(vim.cmd.colorscheme, colorscheme) then
    vim.notify('Failed to load colorscheme' .. colorscheme)
end
