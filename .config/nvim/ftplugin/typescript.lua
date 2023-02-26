local cmp_lsp = require 'cmp_nvim_lsp'
local lsp = vim.lsp
local opt = vim.opt
local bo = vim.bo

bo.shiftwidth = 2
bo.softtabstop = 2
bo.tabstop = 2
opt.wildignore:append '*/node_modules/*'

vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  pattern = '*.ts',
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local server = client.server_capabilities

    -- N.B. workaround formatexpr getting set to vim default
    if server.documentRangeFormattingProvider then
      bo[buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end
  end
})

local settings = {
  ['typescript.format.baseIndentSize'] = bo.tabstop,
  ['typescript.format.indentSize'] = bo.tabstop,
  ['typescript.format.trimTrailingWhitespace'] = true,
  ['typescript.format.convertTabsToSpaces'] = true,
  ['typescript.format.semicolons'] = 'remove',
  ['typescript.format.tabSize'] = bo.tabstop,
  ['typescript.format.insertSpaceAfterFunctionKeywordForAnonymousFunctions'] = true,
  ['typescript.format.insertSpaceAfterKeywordsInControlFlowStatements'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingEmptyBraces'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis'] = true,
  ['typescript.format.insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces'] = true,
  ['typescript.format.insertSpaceAfterSemicolonInForStatements'] = true,
}

vim.lsp.start({
  capabilities = vim.tbl_deep_extend('force',
    lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()),
  cmd = { 'typescript-language-server', '--stdio' },
  init_options = {
    host_info = "neovim",
    preferences = {
      autoImportFileExcludePatterns = {},
      allowIncompleteCompletions = true,
      allowRenameOfImportPath = true,
      allowTextChangesInNewFiles = true,
      disableSuggestions = false,
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true,
      importModuleSpecifierEnding = 'minimal',
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
  },
  name = 'tsserver',
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = settings })
  end,
  root_dir = vim.fs.dirname(vim.fs.find(
    {'tsconfig.json', 'package.json', 'index.ts', 'main.ts' },
    { upward = true, stop = os.getenv('HOME') })[1]),
})
