local shared = {
  -- Auto-imports and completion settings
  autoImportFileExcludePatterns = {}, -- glob patterns to exclude from auto-imports
  generateReturnInDocTemplate = true, -- auto-generate return type in JSDoc
  includeCompletionsWithSnippetText = true, -- include snippet completions
  includeCompletionsWithInsertText = true, -- include insert text completions
  includePackageJsonAutoImports = 'auto', -- 'on' | 'off' | 'auto'

  check = { npmIsInstalled = false }, -- Disable npm installation check
  disableAutomaticTypeAcquisition = true, -- Disable automatic @types/* package acquisition
  format = {
    enabled = true,
    indentSize = 2,
    convertTabsToSpaces = true,
    semicolons = 'remove', -- Remove all semicolons
    insertSpaceAfterCommaDelimiter = true,
    insertSpaceBeforeAndAfterBinaryOperators = true,
    insertSpaceBeforeTypeAnnotation = true,
    organizeImportsCaseFirst = true,
  },
  inlayHints = {
    enabled = true, -- Disable inlay hints globally
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = {
      enabled = "none", -- 'none' | 'literals' | 'all'
      suppressWhenArgumentMatchesName = true,
    },
    parameterTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = false },
    variableTypes = {
      enabled = false,
      suppressWhenTypeMatchesName = true,
    },
  },
  implementationsCodeLens = { enabled = false }, -- Show implementations in code lens
  referencesCodeLens = { enabled = false }, -- Show references in code lens
  preferences = {
    importModuleSpecifier = 'shortest', -- Use shortest possible import paths
    importModuleSpecifierEnding = 'auto',
    includePackageJsonAutoImports = 'on',
    jsxAttributeCompletionStyle = 'auto',
    preferTypeOnlyAutoImports = true,
    quoteStyle = 'single', -- Use single quotes
  },
  suggest = {
    autoImports = true, -- Enable auto-imports
    completeFunctionCalls = false,
    completeJSDocs = true,
    enabled = true,
    includeCompletionsForImportStatements = true,
    paths = true,
  },
  updateImportsOnFileMove = { enabled = 'always' }, -- Auto-update imports on file rename
  validate = { enabled = true }, -- Enable TypeScript validation
}

local vtsls = {
  enableMoveToFileCodeAction = true, -- Enable move to file refactoring

  -- Code lens settings
  codeLens = {
    references = true, -- Show references in code lens
    implementations = true, -- Show implementations in code lens
  },

  -- Diagnostic settings
  diagnostics = {
    ignoredCodes = {}, -- array of diagnostic codes to ignore
    suggestionDiagnostics = true, -- enable suggestion diagnostics
  },

  -- Server settings
  trace = { server = "off" }, -- 'off' | 'messages' | 'verbose'

  experimental = {
    completion = { enableServerSideFuzzyMatch = true }, -- Enable fuzzy matching
    enableProjectDiagnostics = true, -- Enable project-wide diagnostics
  },
  format = {
    baseIndentSize = 2,
    convertTabsToSpaces = true,
    indentSize = 2,
    trimTrailingWhitespace = true,
  },
}

local ts = {
  tsserver = {
    maxTsServerMemory = 8092, -- Max memory allocation for TS server
    useSyntaxServer = 'auto', -- Use syntax server when available
    logVerbosity = "normal", -- 'off' | 'terse' | 'normal' | 'verbose'
    pluginPaths = {}, -- array of paths to TypeScript plugins
    trace = "off", -- 'off' | 'messages' | 'verbose'
    enableProjectDiagnostics = true, -- Enable project-wide diagnostics
    workspaceSymbols = {
      scope = 'allOpenProjects', -- Search in all open projects
      excludeLibrarySymbols = true, -- Exclude node_modules symbols
    },
    -- Project settings
    disableProjectDiagnostics = false,
    packageManager = "npm", -- 'npm' | 'yarn' | 'pnpm'
    -- Code generation
    generateSuggestions = true,
    maxNodeModuleJsDepth = 2, -- depth for searching node_modules
    -- Surveys and telemetry
    surveys = { enabled = false },
  },
}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'yioneko/nvim-vtsls' },
    opts = {
      servers = {
        vtsls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
          },
          setup = function(config)
            local lsp = require 'lspconfig'
            require('lspconfig.configs').vtsls = require('vtsls').lspconfig
            return true
          end,
          settings = {
            javascript = shared,
            typescript = vim.tbl_extend('force', {}, ts, shared),
            vtsls = vtsls,
          },
        },
      }
    }
  },
  { 'yioneko/nvim-vtsls', config = false },
}
