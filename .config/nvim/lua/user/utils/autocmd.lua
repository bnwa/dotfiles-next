local USER_AUGROUP = vim.api.nvim_create_augroup('UserConfig', { clear = true })

local M = {}
local defaults = {
    group = USER_AUGROUP,
    pattern = { '*' },
}

function M.on(evts, params)
    vim.api.nvim_create_autocmd(evts,
        vim.tbl_deep_extend('force', {}, defaults, params))
end

function M.once(evts, params)
    vim.api.nvim_create_autocmd(evts,
        vim.tbl_deep_extend('force', {}, defaults, params, { once = true }))
end

function M.filetype(matches, params)
    vim.api.nvim_create_autocmd('FileType',
        vim.tbl_deep_extend('force', {}, defaults, params))
end

return M
