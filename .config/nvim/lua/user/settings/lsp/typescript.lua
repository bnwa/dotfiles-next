local shared = {
  check = {
    npmIsInstalled = false,
  },
  disableAutomaticTypeAcquisition = true,
  format = {
    enabled = true,
    indentSwitchCase = true,
    insertSpaceAfterCommaDelimiter = true,
    insertSpaceAfterConstructor = false,
    insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
    insertSpaceAfterKeywordsInControlFlowStatements = true,
    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
    insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
    insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
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
  },
  inlayHints = {
    enabled = true,
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    enumMemberValues = {
      enabled = true,
    },
    functionLikeReturnTypes = {
      enabled = true,
    },
    parameterNames = {
      enabled = "all",
      suppressWhenArgumentMatchesName = true,
    },
    parameterTypes = {
      enabled = true,
    },
    propertyDeclarationTypes = {
      enabled = true,
    },
    variableTypes = {
      enabled = true,
      suppressWhenTypeMatchesName = true,
    },
  },
  implementationsCodeLens = {
    enabled = true,
    showOnInterfaceMethods = true,
  },
  preferGoToSourceDefinition = false,
  preferences = {
    importModuleSpecifier = 'shortest',
    importModuleSpecifierEnding = 'auto',
    includePackageJsonAutoImports = 'on',
    jsxAttributeCompletionStyle = 'auto',
    preferTypeOnlyAutoImports = true,
    quoteStyle = 'auto',
    renameMatchingJsxTags = true,
    useAliasesForRenames = false,
  },
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = true,
  },
  reportStyleChecksAsWarnings = true,
  suggest = {
    autoImports = true,
    classMemberSnippets = {
      enabled = true,
    },
    completeFunctionCalls = false,
    completeJSDocs = true,
    enabled = true,
    includeAutomaticOptionalChainCompletions = true,
    includeCompletionsForImportStatements = true,
    jsdoc = {
      generateReturns = true,
    },
    objectLiteralMethodSnippets = {
      enabled = true,
    },
    paths = true,
  },
  suggestionActions = {
    enabled = true,
  },
  updateImportsOnFileMove = {
    enabled = 'always',
  },
  validate = {
    enabled = true,
  },
}

local vtsls_format = {
  format = {
    baseIndentSize = 2,
    convertTabsToSpaces = true,
    indentSize = 2,
    indentStyle = 2,
    trimTrailingWhitespace = true,
  },
}

local vtsls = {
  vtsls = {
    enableMoveToFileCodeAction = true,
    experimental = {
      completion = {
        enableServerSideFuzzyMatch = true,
      },
    },
    javascript = vtsls_format,
    typescript = vtsls_format,
  },
}

local ts = {
  tsserver = {
    experimental = {
      enabledProjectDiagnostics = true,
    },
    useSyntaxServer = 'auto',
    workspaceSymbols = {
      scope = 'allOpenProjects', -- allOpenProjects | currentProject
      excludeLibrarySymbols = true,
    },
  },
}

return {
  settings = {
    javascript = shared,
    typescript = vim.tbl_extend('force', {}, ts, shared),
    vtsls = vtsls,
  }
}

