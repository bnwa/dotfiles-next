return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  config = function()
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
        file_browser = {
          hijack_netrw = true,
        },
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
    scope.load_extension('file_browser')
    scope.load_extension('fzf')
    scope.load_extension('lazy')
    scope.load_extension('ui-select')
    scope.load_extension('undo')
  end,
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
    {
      'nvim-telescope/telescope-file-browser.nvim',
      dependencies = { 'nvim-lua/plenary.nvim'  }
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'tsakirist/telescope-lazy.nvim' },
    { 'debugloop/telescope-undo.nvim' },
  }
}

