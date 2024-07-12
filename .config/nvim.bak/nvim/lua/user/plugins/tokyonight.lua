return {
  'folke/tokyonight.nvim',
  config = function()
    require('tokyonight').setup {
      on_colors = function()end,
      on_highlights = function()end,
      style = 'night',
    }
  end
}

