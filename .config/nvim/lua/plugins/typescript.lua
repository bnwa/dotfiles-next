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
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = true,
  },
}

--- @type LazySpec[]
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
