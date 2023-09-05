local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
local jdtls_ok, jdtls = pcall(require, 'jdtls')
local mason_ok, _ = pcall(require, 'mason')
local path = require 'user.utils.path'
local lsp = vim.lsp
local bo = vim.bo
local fn = vim.fn
local fs = vim.fs

bo.expandtab = true
bo.tabstop = 4
bo.shiftwidth = 4


if not jdtls_ok or not cmp_ok or not mason_ok then return end


--[[
-- TODO name prop must be matched to 'JavaSE-${version}' string format
local function accum_jdk_paths(tbl, str)
  local path_start_idx = string.find(str, '/', 1, true)
  local name_start_idx = string.find(str, '"', 1, true)
  if not path_start_idx then return tbl end
  if not name_start_idx then return tbl end
  table.insert(tbl, {
    name = vim.trim(string.sub(str, name_start_idx, path_start_idx - 1)),
    path = string.sub(str, path_start_idx)
  })
  return tbl
end

local function get_jdk_paths()
  local output = fn.systemlist({
    '/usr/libexec/java_home',
    '-V',
  })
  return fn.reduce(
    vim.list_slice(output, 1, #output - 1),
    accum_jdk_paths,
    {})
end
--]]


local mason_root = fn.stdpath('data') .. '/mason'
local mason_jdtls_workspaces_root = mason_root .. '/share/jdtls/workspaces'
local mason_jdtls_plugins_root = mason_root .. '/packages/jdtls/plugins'
local mason_jdtls_config_root = mason_root .. '/packages/jdtls/config_mac'
local project_root = jdtls.setup.find_root { 'pom.xml', '.git' }

local launcher_jars = fn.glob(mason_jdtls_plugins_root .. '/org.eclipse.equinox.launcher_*.jar')
local workspace_root = mason_jdtls_workspaces_root .. '/' .. fs.basename(project_root)

local capabilities = vim.tbl_deep_extend('force',
  lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities())

local extended_capabilities = vim.tbl_deep_extend('force',
  jdtls.extendedClientCapabilities,
  { resolveAdditionalTextEditsSupport = true })

if not path.is_directory(mason_jdtls_workspaces_root) then
  fn.mkdir(mason_jdtls_workspaces_root, 'p')
end


local config = {}
config.capabilities = capabilities
config.cmd = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xms1g', -- Set initial Java process heap size
  '-Xmx2g', -- Set max Java process heap size
  '--add-modules=ALL-SYSTEM',
  '--add-opens', 'java.base/java.util=ALL-UNNAMED',
  '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  '-jar', launcher_jars,
  '-configuration', mason_jdtls_config_root,
  '-data', workspace_root,
}
config.flags = {
  allow_incremental_sync = true
}
config.init_options = {
  extended_capabilities = extended_capabilities
}
config.on_attach = function(client, _)
  client.notify('workspace/didChangeConfiguration', { settings = config.settings })
end
config.root_dir = project_root
config.settings = {
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
      parameterNames = { enabled = true },
    },
    maven = { downloadSources = true },
    referencesCodeLens = { enabled = true },
    signatureHelp = {
      description = { enabled = true },
      enabled = true
    }
  },
}

jdtls.start_or_attach(config)
