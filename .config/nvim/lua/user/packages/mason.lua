require('mason').setup {
    registries = {
        'github:mason-org/mason-registry',
        'github:bnwa/mason-registry',
    }
}

-- Callback func required for async execution
require('mason-registry').refresh(function()
    require('mason-tool-installer').setup {
        ensure_installed = {
            'vtsls',
        },
        integrations = {
            ['mason-lspconfig'] = false,
        },
        run_on_start = false,
    }
    vim.schedule(function()
        vim.cmd 'MasonToolsUpdate'
    end)
end)
