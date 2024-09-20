local path = require 'user.utils.path'
local fn = vim.fn

local function accum_jdk_paths(tbl, str)
  str = vim.trim(str)
  local name_start_idx = string.find(str, '"', 1, true)
  local path_start_idx = string.find(str, '/', 1, true)
  local ver_str = string.sub(str, 3, 3) == '.' and string.sub(str, 1, 2) or
  string.sub(str, 2, 2) == '.' and string.sub(str, 1, 1) == '1' and string.sub(str, 1, 3) or
  string.sub(str, 2, 2) == '.' and string.sub(str, 1, 1) or
  ''

  if not path_start_idx then return tbl end
  if not name_start_idx then return tbl end
  if ver_str == '' then return tbl end

  table.insert(tbl, {
    name = "JavaSE-" .. ver_str,
    path = string.sub(str, path_start_idx)
  })

  return tbl
end

local function get_jdk_paths()
  local java_home_bin = '/usr/libexec/java_home'
  if path.can_exec(java_home_bin) then
    local output = fn.systemlist({ java_home_bin, '-V', })
    return fn.reduce(
      vim.list_slice(output, 1, #output - 1),
      accum_jdk_paths,
      {})
  end
  return {}
end

return {
  flags = {
    allow_incremental_sync = true,
  },
  java = {
    autobuild = { enabled = true }, -- default: true
    configuration = {
      maven = {
--        globalSettings = "", -- default: nil, settings.xml location
--        lifecycleMappings = "", -- default: nil, mappings xml location
--        userSettings = "", -- default: nil, settings.xml location
      },
      runtimes = get_jdk_paths(),
--      updateBuildConfiguration = "",
    },
    codeGeneration = {
--      addFinalForNewDeclaration = '',
      generateComments = false, -- default: false,
--        insertionLocation = '',
      hashCodeEquals = {
        useInstanceOf = false, -- default: false
        useJava7Objects = false, -- default: false
      },
      toString = {
--        codeStyle = "STRING_CONCATENATION", -- default: 'STRING_CONCATENATION'
--        limitElements = 0, -- default: 0
        listArrayContents = true, -- default: true
        skipNullValues = false, -- default: false
--        template = "",
      },
      useBlocks = false, -- default: false
    },
    completion = {
      chain = { enabled = true },
      collapseCompletionItems = false, -- default: false
      enabled = true, -- default: true
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
--      filteredTypes = {},
      -- when true, guessing in-scope vals to pass; false, insert param names
      guessMethodArguments = true,
--      importOrder = {}, -- default: { 'java', 'javax', 'org', 'com' }
      lazyResolveTextEdit = { enabled = false }, -- default: false
      -- 'FIRSTLETTER' | 'OFF'
      matchCase = 'OFF', -- default: 'OFF'
      maxResults = 50, -- default: 50
      overwrite = true, -- default: true
      postfix = { enabled = true }, -- default: true
    },
    foldingRange = { enabled = true }, -- default: true
    eclipse = {
      downloadSources = false, --default: false
    },
    edit = {
      smartSemicolonDetection = { enabled = true }, -- default: false
      validateAllOpenBuffersOnChanges = true, -- default: true
    },
    errors = {
--      incompleteClassPath = { severity = "" }, -- default: 'warning'
    },
    executeCommand = { enabled = true }, -- default: true
    format = {
      comments = true, -- default: true
      enabled = true, -- default: true
      insertSpaces = true, -- default: true
      onType = { enabled = false }, -- default: false
      tabSize = 4, -- default: 4
    },
    implementationsCodeLens = { enabled = true }, -- default: false
    import = {
      -- default: [ '**/node_modules/**, **/.metadata/**, **/archetype-resources/**, **/META-INF/maven/** ]
--      exclusions = {},
      gradle = {
        annotationProcessing = { enabled = false },
--        arguments = {},
        enabled = false, --default: false
--        home = "",
--        java = { home = "" },
--        jvmArguments = {},
        offline = { enabled = false }, -- default: false
--        user = { home = "" }
        wrapper = { enabled = false }, -- default: true
--        version = "",
      },
    },
    inlayHints = {
      -- Disabling until JDTLS bug in neovim is fixed
      -- 'none' | 'literals' | 'all'
      parameterNames = { enabled = 'none' }, -- default: 'all'
    },
    maxConcurrentBuilds = 1, -- default: 1
    maven = {
      downloadSources = true, -- default: false
      updateSnapshots = true, -- default: false
    },
    -- How member elements are ordered by code actions
    memberSortOrder = {
      'T', -- Types
      'F', -- Fields
      'SF', -- Static Fields
      'C', -- Constructors
      'I', -- Initializers
      'SI', -- Static Initializers
      'SM', -- Static Methods
      'M', -- Methods
    },
    project = {
      encoding = 'UTF-8',
--      outputPath = "", -- default: ""
--      referencedLibraries = {}, -- default: [ 'lib/**' ]
--      resourcesFilters = {}, -- default: [ 'node_modules', '.git']
--      sourcePaths = {}, -- default: nil
    },
    refactoring = {
      extract = {
        interface = {
          replace = false, -- default: false
        }
      }
    },
    references = {
      includeAccessors = true, -- default: true
      includeDecompiledSources = true, -- default: true
    },
    referencesCodeLens = { enabled = true }, -- default: true
    rename = { enabled = true }, -- default: true
    saveActions = {
      organizeImports = true, -- default: false
    },
    selectionRange = { enabled = true }, -- default: true
    signatureHelp = {
      description = { enabled = true }, -- default: false
      enabled = true, -- default: true
    },
    sources = {
      organizeImports = {
        -- number of imports added before a star-import declaration is used.
        starThreshold = 99, -- default: 99
        staticStarThreshold = 10, -- default: 99
      }
    },
    symbols = {
      includeSourceMethodDeclarations = true -- default: false
    },
    telemetry = { enabled = false },
  },
}
