return {
  'rose-pine/neovim',
  config = function()
    require('rose-pine').setup {
      dim_inactive_widows = true,
      enable = {
        legacy_highlights = false,
      },
    }
  end,
  name = 'rose-pine',
}
