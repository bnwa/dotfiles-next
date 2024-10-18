return {
  'gbprod/yanky.nvim',
  dependencies = {
    'kkharji/sqlite.lua',
    'chrisgrieser/cmp_yanky',
    'nvim-telescope/telescope.nvim',
  },
  opts = function()
    local mapping = require 'yanky.telescope.mapping'
    return {
      highlight = {
        timer = 150,
      },
      picker = {
        telescope = {
          mappings = {
            n = {
              [']p'] = mapping.special_put('YankyPutIndentAfterLinewise'),
              [']P'] = mapping.special_put('YankyPutIndentBeforeLinewise'),
            },
          },
          use_default_mappings = true,
        }
      },
      ring = {
        storage = 'sqlite',
      }
    }
  end,
  config = function(_, opts)
    require('yanky').setup(opts)
    -- Plugin author calls into telescope to resolve
    -- 'yanky.telescope.mapping', but this instructs
    -- lazy.nvim to setup telescop and calling
    -- load_extension there will break b/c yanky isn't
    -- done writing to the module cache
    require('telescope').load_extension('yank_history')
  end,
}
