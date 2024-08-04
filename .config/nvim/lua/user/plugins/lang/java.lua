local settings = require 'user.settings.lsp.java'
local autocmd = require 'user.utils.autocmd'
local path = require 'user.utils.path'

local fn = vim.fn
local fs = vim.fs

local ft = {'java'}

return {
  {
    'nvim-java/nvim-java',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jdtls = {
          filetypes = ft,
--[[ Handled by nvim-java
          init_options = {
            extended_capabilities = {
              actionableNotificationSupported = false, -- default: false
              actionableRuntimeNotificationSupport = false, -- default: false
              advancedExtractRefactoringSupport = false, -- default: false
              advancedGenerateAccessorsSupport = false, -- default: false
              advancedIntroduceParameterRefactoringSupport = false, -- default: false
              advancedOrganizeImportsSupport = false, -- default: false
              advancedUpgradeGradleSupport = false, -- default: false
              classFileContentsSupport = false, -- default: false
              clientDocumentSymbolProvider = false, -- default: false
              clientHoverProvider = false, -- default: false
              excludedMarkerTypes = {}, -- default: []
              extractInterfaceSupport = false, -- default: false
              generateConstructorsPromptSupport = false, -- default: false
              generateDelegateMethodsPromptSupport = false, -- default: false
              generateToStringPromptSupport = false, -- default: false
              gradleChecksumWrapperPromptSupport = false,-- default: false
              hashCodeEqualsPromptSupport = false, -- default: false
              inferSelectionSupport = false,-- default: false
              moveRefactoringSupport = false,-- default: false
              onCompletionItemSelectedCommand = false,-- default: false
              overrideMethodsPromptSupport = false,-- default: false
              progressReportProvider = false, -- default: false
              shouldLanguageServerExitOnShutdown = false,-- default: false
              skipProjectConfiguration = false, -- default: false
              skipTextEventPropagation = false, -- default: false
            }
          },
--]]
          on_attach = function(client, _)
            client.notify('workspace/didChangeConfiguration', {
              settings = settings
            })
          end,
          settings = settings,
          setup = function(config)
            require('java').setup {}
            require('lspconfig').jdtls.setup(config)
          end,
        },
      },
    },
  },
}
