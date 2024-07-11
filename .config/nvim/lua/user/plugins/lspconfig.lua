-- Created in init.lua
local autocmd = require 'user.utils.autocmd'
local NOOP = function()end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
  },
  config = function()
    local schemas = require 'schemastore'
    local libraries = vim.api.nvim_get_runtime_file("", true)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local tsConfig = {
      format = {
        baseIndentSize = 2,
        convertTabsToSpaces = true,
        indentSize = 2,
        indentStyle = 'Smart',
        insertSpaceAfterCommanDelimiter = true,
        insertSpaceAfterConstructor = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = true,
        insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = true,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterTypeAssertion = true,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        insertSpaceBeforeFunctionParenthesis = false,
        insertSpaceBeforeTypeAnnotation = true,
        organizeImportsIgnoreCase = false,
        organizeImportsCaseFirst = true,
        placeOpenBraceOnNewLineForControlBlocks = false,
        placeOpenBraceOnNewLineForFunctions = false,
        semicolons = 'remove',
        trimTrailingWhitespace = true,
      },
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
    }

    local servers = {
      jsonls = {
        settings = {
          json = {
            allowComments = true,
            schemas = schemas.json.schemas(),
            validate = { enabled = true },
          }
        }
      },
      lemminx = {},
      lua_ls = {
        settings = {
          Lua = {
            completion ={
              autoRequire = true,
              callSnippet = "Replace",
              enable = true,
              keywordSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            hint = {
              enable = true,
              setType = true,
            },
            runtime = {
              path = {
                '?.lua',
                '?/init.lua',
              },
              version = "LuaJIT",
            },
            telemetry = {
              enable = false,
            },
            workspace = {
              checkThirdParty = false,
              library = libraries,
            },
          }
        }
      },
      tsserver = {
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
          diagnostics = {
            ignoredCodes = {
              80001, -- File can be converted to ES module
              80002  -- Function can be converted to class
            },
          },
          javascript = tsConfig,
          typescript = tsConfig,
        }
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, { 'jdtls' })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = autocmd.augroup,
      callback = function(_)end,
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server_config = servers[server_name] or {}

          server_config.capabilities = vim.tbl_deep_extend('force',
            capabilities,
            server_config.capabilities or {})

          require('lspconfig')[server_name].setup(server_config)
        end,
        ['jdtls'] = NOOP,
      },
    }
  end,
}
