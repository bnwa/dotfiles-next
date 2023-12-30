return {
  'rafcamlet/nvim-luapad',
  config = function()
    require('luapad').setup {
      eval_on_change = false
    }
  end
}

