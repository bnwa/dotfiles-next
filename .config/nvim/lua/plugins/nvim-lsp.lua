return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            flags = {
              allow_incremental_sync = true,
            },
            java = {
              configuration = {
                runtimes = {
                  { name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home" },
                  { name = "JavaSE-1.8", path = "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home" },
                },
              },
              completion = {
                chain = { enabled = true },
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "org.junit.jupiter.api.Assumptions.*",
                  "org.junit.jupiter.api.DynamicContainer.*",
                  "org.junit.jupiter.api.DynamicTest.*",
                  "org.mockito.Mockito.*",
                },
              },
              implementationsCodeLens = { enabled = true },
              inlayHints = {
                parameterNames = { enabled = "all" },
              },
              maven = {
                downloadSources = true,
                updateSnapshots = true,
              },
              references = {
                includeDecompiledSources = true,
              },
              referencesCodeLens = { enabled = true },
              signatureHelp = {
                description = { enabled = true },
                enabled = true,
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              jdk = {
                auto_install = false,
              },
            })
          end,
        },
      },
    },
  },
}
