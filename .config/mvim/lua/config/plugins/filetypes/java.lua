local util = require 'config.utils.java'
local autocmd = require 'config.utils.autocmd'

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'JavaHello/spring-boot.nvim',
    ft = { 'java', 'jproperties' },
    dependencies = {
      'ibhagwan/fzf-lua',
      'williamboman/mason.nvim',
    },
    config = function()
      local spring_boot = require 'spring_boot'
      local spring_boot_path = vim.fn.stdpath('data') .. '/mason/packages/vscode-spring-boot-tools'
      local spring_boot_ls_path = spring_boot_path .. '/extension/language-server'
      vim.g.spring_boot = vim.g.spring_boot or {}
      vim.g.spring_boot.jdt_extensions_path = spring_boot_path .. '/extensions/jars'
      spring_boot.setup({
        ls_path = vim.fn.glob(spring_boot_ls_path .. '/spring-boot-language-server-*-exec.jar')[1],
        log_file = vim.fn.stdpath('state') .. '/lsp.log',
        exploded_ls_jar_data = true,
      })
      spring_boot.init_lsp_commands()
    end
  },
  {
    'elmcgill/springboot-nvim',
    ft = 'java',
    depenedencies = {},
  },
  {
    'mfussenegger/nvim-jdtls',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- 'rcarriga/nvim-dap-ui',
      -- 'mfussenegger/nvim-dap',
    },
    config = false,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function()
      local bundles = {}
      local registry = require 'mason-registry'
      local jdtls = require 'jdtls'
      local platform = require 'config.utils.platform'
      -- local dap = require 'jdtls.dap'

      local jdtls_pkg = registry.get_package('jdtls')
      local jdtls_path = jdtls_pkg:get_install_path()
      local plugins_path = jdtls_path .. '/plugins'
      --local agent_path = jdtls_path .. '/lombok.jar'
      local launcher_path = vim.fn.glob(plugins_path .. '/org.eclipse.equinox.launcher_*.jar')
      local platform_path =
      platform.os.mac and jdtls_path .. '/config_mac' or
      platform.os.linux and jdtls_path .. '/config_linux' or
      platform.os.win and jdtls_path .. '/config_win'

      -- local java_test_pkg = registry.get_package('java-test')
      -- local java_test_path = java_test_pkg:get_install_path()
      -- local java_test_exts = java_test_path .. '/extension/server/*.jar'
      -- local java_test_bundle = vim.split(vim.fn.glob(java_test_exts), '\n')
      -- vim.list_extend(bundles, java_test_bundle)
      -- if java_test_bundle[1] ~= "" then
      --   vim.list_extend(bundles, java_test_bundle)
      -- end

      local spring_boot_pkg = registry.get_package('vscode-spring-boot-tools')
      local spring_boot_path = spring_boot_pkg:get_install_path()
      local spring_boot_exts = spring_boot_path .. '/extension/jars/*.jar'
      local spring_boot_bundle = vim.split(vim.fn.glob(spring_boot_exts), '\n')
      vim.list_extend(bundles, spring_boot_bundle)

      -- local java_debug_pkg = registry.get_package('java-debug-adapter')
      -- local java_debug_path = java_debug_pkg:get_install_path()
      -- local java_debug_exts = java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'
      -- local java_debug_bundle = vim.split(vim.fn.glob(java_debug_exts), '\n')
      -- vim.list_extend(bundles, java_debug_bundle)
      -- if java_debug_bundle[1] ~= "" then
      --   vim.list_extend(bundles, java_debug_bundle)
      -- end

      local extended_capabilities = vim.tbl_deep_extend('force',
        {},
        jdtls.extendedClientCapabilities,
        { resolveAdditionalTextEditsSupport = true })

      return {
        servers = {
          jdtls = {
            filetypes = {
              'java',
            },
            settings = {
              flags = {
                allow_incremental_sync = true,
              },
              java = {
                autobuild = { enabled = true }, -- default: true
                configuration = {
                  runtimes = util.get_jdk_paths(),
                },
                codeGeneration = {
                  generateComments = false, -- default: false,
                  hashCodeEquals = {
                    useInstanceOf = false, -- default: false
                    useJava7Objects = false, -- default: false
                  },
                  toString = {
                    listArrayContents = true, -- default: true
                    skipNullValues = false, -- default: false
                  },
                  useBlocks = false, -- default: false
                },
                completion = {
                  chain = { enabled = true },
                  collapseCompletionItems = false, -- default: false
                  enabled = true, -- default: true
                  favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.jupiter.api.Assumptions.*",
                    "org.junit.jupiter.api.DynamicContainer.*",
                    "org.junit.jupiter.api.DynamicTest.*",
                    "org.mockito.Mockito.*",
                  },
                  -- when true, guessing in-scope vals to pass; false, insert param names
                  guessMethodArguments = true,
                  lazyResolveTextEdit = { enabled = false }, -- default: false
                  -- 'FIRSTLETTER' | 'OFF'
                  matchCase = "OFF", -- default: 'OFF'
                  maxResults = 50, -- default: 50
                  overwrite = true, -- default: true
                  postfix = { enabled = true }, -- default: true
                },
                foldingRange = { enabled = true }, -- default: true
                eclipse = {
                  downloadSources = false, --default: false
                },
                edit = {
                  smartSemicolonDetection = { enabled = true }, -- default: false
                  validateAllOpenBuffersOnChanges = true, -- default: true
                },
                executeCommand = { enabled = true }, -- default: true
                format = {
                  comments = true, -- default: true
                  enabled = true, -- default: true
                  insertSpaces = true, -- default: true
                  onType = { enabled = false }, -- default: false
                  tabSize = 4, -- default: 4
                },
                implementationsCodeLens = { enabled = true }, -- default: false
                inlayHints = {
                  -- Disabling until JDTLS bug in neovim is fixed
                  -- 'none' | 'literals' | 'all'
                  parameterNames = { enabled = "none" }, -- default: 'all'
                },
                maxConcurrentBuilds = 1, -- default: 1
                maven = {
                  downloadSources = true, -- default: false
                  updateSnapshots = true, -- default: false
                },
                -- How member elements are ordered by code actions
                memberSortOrder = {
                  "T", -- Types
                  "F", -- Fields
                  "SF", -- Static Fields
                  "C", -- Constructors
                  "I", -- Initializers
                  "SI", -- Static Initializers
                  "SM", -- Static Methods
                  "M", -- Methods
                },
                project = {
                  encoding = "UTF-8",
                },
                refactoring = {
                  extract = {
                    interface = {
                      replace = false, -- default: false
                    },
                  },
                },
                references = {
                  includeAccessors = true, -- default: true
                  includeDecompiledSources = true, -- default: true
                },
                referencesCodeLens = { enabled = true }, -- default: true
                rename = { enabled = true }, -- default: true
                saveActions = {
                  organizeImports = true, -- default: false
                },
                selectionRange = { enabled = true }, -- default: true
                signatureHelp = {
                  description = { enabled = true }, -- default: false
                  enabled = true, -- default: true
                },
                sources = {
                  organizeImports = {
                    -- number of imports added before a star-import declaration is used.
                    starThreshold = 99, -- default: 99
                    staticStarThreshold = 10, -- default: 99
                  },
                },
                symbols = {
                  includeSourceMethodDeclarations = true, -- default: false
                },
                telemetry = { enabled = false },
              },
            },
            setup = function(config)
              autocmd.filetype({'java'}, function()
                --local spring_nvim = require 'springboot-nvim'
                local project_path = vim.fn.fnamemodify(vim.fs.find({
                  '.git',
                  'mvnw',
                  'gradlew',
                  'pom.xml',
                  'build.gradle',
                }, { upward = true })[1], ':h')
                local workspace_path = vim.fn.stdpath('cache') .. '/' .. vim.fn.fnamemodify(project_path, ':t')
                jdtls.start_or_attach({
                  capabilities = config.capabilities,
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
                  settings = config.settings,
                })
              end)
            end,
          }
        }
      }
    end
  }
}
