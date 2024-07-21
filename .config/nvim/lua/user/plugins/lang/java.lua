local server_config = require 'user.settings.lsp.java'
local autocmd = require 'user.utils.autocmd'
local path = require 'user.utils.path'

local fn = vim.fn
local fs = vim.fs

local ft = {'java'}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-jdtls',
    },
    ft = ft,
    opts = {
      servers = {
        jdtls = {
          on_attach = function(client, _)
            client.notify('workspace/didChangeConfiguration', {
              settings = server_config
            })
          end,
          filetypes = ft,
          server_config = server_config,
          setup = function(config)
            local jdtls = require 'jdtls'
            local mason_root = fn.stdpath('data') .. '/mason'
            local mason_jdtls_workspaces_root = mason_root .. '/share/jdtls/workspaces'
            local mason_jdtls_plugins_root = mason_root .. '/packages/jdtls/plugins'
            local mason_jdtls_config_root = mason_root .. '/packages/jdtls/config_mac'
            local launcher_jars = fn.glob(mason_jdtls_plugins_root .. '/org.eclipse.equinox.launcher_*.jar')
            local extended_capabilities = vim.tbl_deep_extend('force',
            vim.deepcopy(jdtls.extendedClientCapabilities),
            { resolveAdditionalTextEditsSupport = true })

            if not path.is_directory(mason_jdtls_workspaces_root) then
              fn.mkdir(mason_jdtls_workspaces_root, 'p')
            end

            autocmd.filetype(config.filetypes, function()
              local project_root = fs.root(0, { '.git', "mvnw", "gradlew"  })
              local workspace_root = mason_jdtls_workspaces_root .. '/' .. fs.basename(project_root)
              jdtls.start_or_attach({
                capabilities = config.capabilities,
                flags = {
                  allow_incremental_sync = true,
                },
                init_options = {
                  extended_capabilities = extended_capabilities,
                },
                root_dir = project_root,
                settings = config.server_config,
                on_attach = function(client, _)
                  client.notify('workspace/didChangeConfiguration', {
                    settings = config.server_config
                  })
                end,
                cmd = {
                  'java',
                  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                  '-Dosgi.bundles.defaultStartLevel=4',
                  '-Declipse.product=org.eclipse.jdt.ls.core.product',
                  '-Dlog.protocol=true',
                  '-Dlog.level=ALL',
                  '-Xms1g', -- Set initial Java process heap size
                  '-Xmx2g', -- Set max Java process heap size
                  '--add-modules=ALL-SYSTEM',
                  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                  '-jar', launcher_jars,
                  '-configuration', mason_jdtls_config_root,
                  '-data', workspace_root,
                }
              })
            end)
            return true
          end,
        },
      },
    }
  },
}
