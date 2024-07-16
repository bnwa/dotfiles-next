local path = require 'user.utils.path'

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'tsakirist/telescope-lazy.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    opts = function()
      local scope = require 'telescope'
      scope.setup {
        defaults = {
          dynamic_preview_title = true,
          entry_prefix = '○ ',
          layout_config = {
            preview_cutoff = 20,
          },
          layout_strategy = 'vertical',
          selection_caret = '➞ ',
          wrap_results = true,
        },
        extensions = {
          fzf = {
            case_mode = 'smart_case',
            fuzzy = true,
            override_file_sorter = true,
            override_generic_sorter = true,

          },
          lazy = {
            show_icon = true,
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
          undo = {
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.8,
            },
          },
        },
      }
      scope.load_extension('fzf')
      scope.load_extension('lazy')
      scope.load_extension('ui-select')
      scope.load_extension('undo')
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
}
