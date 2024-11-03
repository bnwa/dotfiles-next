local path = require 'user.utils.path'
local autocmd = require 'user.utils.autocmd'
local platform = require 'user.utils.platform'
local java_lsp_cfg = require 'user.settings.lsp.java'

local lsp = vim.lsp
local fn = vim.fn
local function setup(config)
  local bundles = {}
  local cmp_lsp = require 'cmp_nvim_lsp'
  local registry = require 'mason-registry'
  local jdtls = require 'jdtls'
  local dap = require 'jdtls.dap'

  local jdtls_pkg = registry.get_package('jdtls')
  local jdtls_path = jdtls_pkg:get_install_path()
  local cache_path = fn.stdpath('cache') .. '/jdtls'
  local plugins_path = jdtls_path .. '/plugins'
  local platform_path =
    platform.os.mac and jdtls_path .. '/config_mac' or
    platform.os.linux and jdtls_path .. '/config_linux' or
    platform.os.win and jdtls_path .. '/config_win'

  local java_test_pkg = registry.get_package('java-test')
  local java_test_path = java_test_pkg:get_install_path()
  local java_test_exts = java_test_path .. '/extension/server/*.jar'
  local java_test_bundle = vim.split(vim.fn.glob(java_test_exts), '\n')
  vim.list_extend(bundles, java_test_bundle)
  if java_test_bundle[1] ~= "" then
    vim.list_extend(bundles, java_test_bundle)
  end

  local spring_boot_pkg = registry.get_package('spring-boot-tools')
  local spring_boot_path = spring_boot_pkg:get_install_path()
  --local spring_boot_ls_path = spring_boot_path .. '/extension/language-server'
  local spring_boot_exts = spring_boot_path .. '/extension/jars/*.jar'
  local spring_boot_bundle = vim.split(fn.glob(spring_boot_exts), '\n')
  vim.list_extend(bundles, spring_boot_bundle)

  local java_debug_pkg = registry.get_package('java-debug-adapter')
  local java_debug_path = java_debug_pkg:get_install_path()
  local java_debug_exts = java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'
  local java_debug_bundle = vim.split(fn.glob(java_debug_exts), '\n')
  vim.list_extend(bundles, java_debug_bundle)
  if java_debug_bundle[1] ~= "" then
    vim.list_extend(bundles, java_debug_bundle)
  end

  --local agent_path = jdtls_path .. '/lombok.jar'
  local launcher_path = fn.glob(plugins_path .. '/org.eclipse.equinox.launcher_*.jar')

  local capabilities = config.capabilities

  local settings = config.settings

  local extended_capabilities = vim.tbl_deep_extend('force',
    {},
    jdtls.extendedClientCapabilities,
    { resolveAdditionalTextEditsSupport = true })

  return function ()
    --local spring_nvim = require 'springboot-nvim'
    local project_path = fn.fnamemodify(vim.fs.find({
      '.git',
      'mvnw',
      'gradlew',
      'pom.xml',
      'build.gradle',
    }, { upward = true })[1], ':h')
    vim.print(project_path)
    local workspace_path = cache_path .. '/' .. fn.fnamemodify(project_path, ':t')
    jdtls.start_or_attach({
      capabilities = capabilities,
      cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
--        '-javaagent:' ..agent_path,
        '-Xms1g', -- Set initial Java process heap size
        '-Xmx2g', -- Set max Java process heap size
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', launcher_path,
        '-configuration', platform_path,
        '-data', workspace_path,
      },
      flags = {
        allow_incremental_sync = true
      },
      init_options = {
        bundles = bundles,
        extendedClientCapabilities = extended_capabilities,
      },
      on_attach = config.on_attach,
      root_dir = project_path,
      settings = settings,
    })
  end
end

return {
  {
    'JavaHello/spring-boot.nvim',
    ft = 'java',
    dependencies = {
      'ibhagwan/fzf-lua',
      'williamboman/mason.nvim',
    },
    config = function()
      local spring_boot = require 'spring_boot'
      local spring_boot_path = "/Users/barberousse.benoit/.local/share/nvim/mason/packages/spring-boot-tools"
      local spring_boot_ls_path = spring_boot_path .. '/extension/language-server'
      vim.g.spring_boot.jdt_extensions_path = spring_boot_path .. '/extensions/jars'
      spring_boot.setup({
        ls_path = spring_boot_ls_path,
        log_file = fn.stdpath('state') .. '/lsp.log',
        exploded_ls_jar_data = true,
      })
      spring_boot.init_lsp_commands()
    end
  },
  {
    'elmcgill/springboot-nvim',
    ft = 'java',
    depenedencies = {
    },
    config = false
  },
  {
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap',
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mfussenegger/nvim-jdtls',
      'elmcgill/springboot-nvim',
      'JavaHello/spring-boot.nvim',
    },
    opts = {
      servers = {
        jdtls = {
          on_attach = function(client, buf)
            local jdtls = require 'jdtls'
            local dap = require 'jdtls.dap'
            client.notify('workspace/didChangeConfiguration', { settings = java_lsp_cfg })
            if client.supports_method('textDocument/inlayHint', { bufnr = buf })
              and vim.api.nvim_buf_is_valid(buf)
              and vim.bo[buf].buftype == '' then
              vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            end
            if client.supports_method('textDocument/codeLens', { bufnr = buf })
              and vim.api.nvim_buf_is_valid(buf)
              and vim.bo[buf].buftype == '' then
              vim.lsp.codelens.refresh()
              autocmd.buffer("Refresh code lens", buf,
              { 'BufWritePost'},
              function()
                vim.lsp.codelens.refresh()
              end)
            end
            jdtls.setup_dap({ hotcodereplace = 'auto' })
            dap.setup_dap_main_class_configs()
          end,
          settings = require 'user.settings.lsp.java',
          setup = function(config)
            autocmd.filetype({'Java'}, setup(config))
          end
        }
      }
    }
  }
}
