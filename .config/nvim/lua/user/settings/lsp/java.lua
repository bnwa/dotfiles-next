local path = require 'user.utils.path'
local fn = vim.fn

local function accum_jdk_paths(tbl, str)
  str = vim.trim(str)
  local name_start_idx = string.find(str, '"', 1, true)
  local path_start_idx = string.find(str, '/', 1, true)
  local ver_str = string.sub(str, 3, 3) == '.' and string.sub(str, 1, 2) or
  string.sub(str, 2, 2) == '.' and string.sub(str, 1, 1) == '1' and string.sub(str, 3, 3) or
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
  local jdk_paths = {}
  local java_home_bin = '/usr/libexec/java_home'
  if path.can_exec(java_home_bin) then
    local output = fn.systemlist({ java_home_bin, '-V', })
    return fn.reduce(
      vim.list_slice(output, 1, #output - 1),
      accum_jdk_paths,
      jdk_paths)
  end
  return jdk_paths
end

return {
  flags = {
    allow_incremental_sync = true,
  },
  java = {
    configuration = {
      runtimes = get_jdk_paths(),
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
      enabled = true
    }
  },
}
