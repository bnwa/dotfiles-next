local config = {
  format = {
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
    semicolons = "remove",
  },
  implementationsCodeLens = {
    enabled = true,
    showOnInterfaceMethods = true,
  },
  inlayHints = {
    enumMemberValues = { enabled = false },
    functionLikeReturnTypes = { enabled = false },
    parameterNames = { enabled = "none" },
    parameterTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = false },
    variableTypes = { enabled = false },
  },
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = true,
  },
}

---@module 'lazy'
---@type LazySpec[]
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            javascript = config,
            typescript = config,
          },
        },
      },
    },
  },
}
