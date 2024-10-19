require('mason').setup {
    registries = {
        'github:mason-org/mason-registry',
        'github:bnwa/mason-registry',
    }
}

-- Callback func required for async execution
require('mason-registry').refresh(function()end)
