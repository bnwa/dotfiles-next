local cmp_ok, cmp_lsp = pcall(require,'cmp_nvim_lsp')
local new_cmd = vim.api.nvim_create_user_command
local utils = require 'user.utils.lsp'
local lsp = vim.lsp
local opt = vim.opt_local
local bo = vim.bo

bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2
opt.wildignore:append '*/node_modules/*'

if not cmp_ok then return end


local config = {
  format = {
    baseIndentSize = bo.softtabstop,
    convertTabsToSpaces = true,
    indentSize = bo.softtabstop,
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

local settings = {
  completions = {
    completeFunctionCalls = true,
  },
  diagnostics = {
    ignoredCodes = {
      80001, -- File can be converted to ES module
      80002  -- Function can be converted to class
    },
  },
 --  implicitProjectConfiguration = {
 --    checkJs = true,
 --  },
  javascript = config,
  typescript = config,
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
      organizeImportsCaseFirst = 'upper',
      organizedImportsCollation = 'unicode',
      organizeImportsIgnoreCase = false,
      providePrefixAndSuffixTextForRename = false,
      quotePreference = 'single',
      useLabelDetailsInCompletionEntries = true,
    },
  },
  name = 'tsserver',
  on_attach = function(client, bufnr)
    local server = client.server_capabilities

    local function renameFile(meta)
      local src = meta.fargs[1] or vim.api.nvim_buf_get_name(bufnr)
      vim.ui.input({ prompt = "New Path: ", default = src }, function(input)
        if input == nil then return end
        utils.lspRenameFile(client, src, input)
      end)
    end

    -- N.B. workaround formatexpr getting set to vim default
    if server.documentRangeFormattingProvider then
      bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end

    new_cmd('RenameFile', renameFile, {
      desc = "Specify new file path for a buffer supported by typescript-language-server",
      nargs = '?',
    })
  end,
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = settings })
  end,
  root_dir = vim.fs.dirname(vim.fs.find(
    {'tsconfig.json', 'package.json', 'index.ts', 'main.ts' },
    { upward = true, stop = os.getenv('HOME') })[1]),
})
