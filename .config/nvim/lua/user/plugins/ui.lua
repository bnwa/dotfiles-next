local keymap = require 'user.settings.keymap'

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
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
            vertical = {
              mirror = true,
              prompt_position = 'top',
            },
            preview_cutoff = 20,
          },
          layout_strategy = 'vertical',
          path_display = {'smart'},
          preview = {
            filetype_hook = function(path, buf, opts)
              if opts.ft == 'bigfile' then
                local pre = require 'telescope.previewers.utils'
                local msg = "File too large to preview"
                pre.set_preview_message(buf, opts.winid, msg)
                return false
              else
                return true
              end
            end,
            treesitter = true,
          },
          prompt_prefix = ' ',
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
  {
    "folke/which-key.nvim",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      preset = 'modern',
      spec = keymap,
      win = {
        border = 'double'
      }
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = true,
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = 'float',
      float_opts = {
        border = 'double',
        title_pos = 'center',
      },
      open_mapping = [[<C-\>]],
    },
  },
  {
    "tzachar/highlight-undo.nvim",
  },
  { 'echasnovski/mini.animate', version = '*' }
}
