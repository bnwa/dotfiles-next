return {
  'echasnovski/mini.icons',
  version = false,
  opts = {
    lsp = { Copilot = "" }
  },
  config = function(_, opts)
    require('mini.icons').setup(opts)
    MiniIcons.mock_nvim_web_devicons()
    MiniIcons.tweak_lsp_kind("prepend")
  end
}
