local lua_libs = vim.api.nvim_get_runtime_file("", true)
local js_ts_lang_config = {
  format = {
    baseIndentSize = 2,
    convertTabsToSpaces = true,
    indentSize = 2,
    indentStyle = "Smart",
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
    semicolons = "remove",
    trimTrailingWhitespace = true,
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all",
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
return {
  "neovim/nvim-lspconfig",
  opts = {
    codelens = {
      enabled = true,
    },
    servers = {
      lemminx = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
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
                "?.lua",
                "?/init.lua",
              },
              version = "LuaJIT",
            },
            telemetry = {
              enable = false,
            },
            workspace = {
              checkThirdParty = false,
              library = lua_libs,
            },
          },
        },
      },
      vtsls = {
        typescript = js_ts_lang_config,
        javascript = js_ts_lang_config,
      },
    },
  },
}
