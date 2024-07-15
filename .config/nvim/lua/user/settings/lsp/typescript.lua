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

return {
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
}

