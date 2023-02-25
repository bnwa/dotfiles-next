local cmp_lsp = require 'cmp_nvim_lsp'
local lsp = vim.lsp
local opt = vim.opt

opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.wildignore:append '*/node_modules/*'

vim.lsp.start({
  capabilities = vim.tbl_deep_extend('force',
    lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()),
  cmd = { 'typescript-language-server', '--stdio' },
  init_options = {
    host_info = "neovim",
    preferences = {
      allowIncompleteCompletions = true,
      allowRenameOfImportPath = true,
      allowTextChangesInNewFiles = true,
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsForModuleExports = true,
      includeCompletionsWithClassMemberSnippets = true,
      includeCompletionsWithInsertText = true,
      includeCompletionsWithObjectLiteralMethodSnippets = true,
      includeCompletionsWithSnippetText = true,
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayParameterNameHints = 'all',
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      jsxAttributeCompletionStyle = 'auto',
      providePrefixAndSuffixTextForRename = true,
      quotePreference = 'double',
      useLabelDetailsInCompletionEntries = true,
    },
    settings = {
      ['typescript.format.baseIndentSize'] = opt.tabstop:get(),
      ['typescript.format.indentSize'] = opt.tabstop:get(),
      ['typescript.format.trimTrailingWhitespace'] = true,
      ['typescript.format.convertTabsToSpaces'] = true,
      ['typescript.format.semicolons'] = 'remove',
      ['typescript.format.tabSize'] = opt.tabstop:get(),
      ['typescript.format.insertSpaceAfterFunctionKeywordForAnonymousFunctions'] = true,
      ['typescript.format.insertSpaceAfterKeywordsInControlFlowStatements'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingEmptyBraces'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis'] = true,
      ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces'] = true,
      ['typescript.format.insertSpaceAfterSemicolonInForStatements'] = true,
    },
  },
  name = 'tsserver',
  root_dir = vim.fs.dirname(vim.fs.find(
    {'tsconfig.json', 'package.json', 'index.ts', 'main.ts' },
    { upward = true })[1]),
})
