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
      return {
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
          path_display = {'truncate'},
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
    end,
    config = function(_, opts)
      local scope = require 'telescope'
      scope.setup(opts)
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
        border = 'rounded'
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
        border = 'rounded',
        title_pos = 'center',
      },
      open_mapping = [[<C-\>]],
    },
  },
  {
    "tzachar/highlight-undo.nvim",
  },
  { 'echasnovski/mini.animate', version = '*' },
  {
    "folke/noice.nvim",
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        documentation = {
          opts = {
            win_opts = { border = 'rounded' },
          },
        },
        signature = {
          auto_open  = {
            luasnip = false,
          },
        },
      },
      override = {
        -- override the default lsp markdown formatter with Noice
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        -- override the lsp markdown formatter with Noice
        ["vim.lsp.util.stylize_markdown"] = true,
        -- override cmp documentation with Noice (needs the other options to work)
        ["cmp.entry.get_documentation"] = true,
      },
      popupmenu = {
        backend = 'nui'
      },
      presets = {
        command_palette = true,
      }
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        globalstatus = true,
        ignore_focus = {
          'netrw',
        },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          {
            'filename',
            newfile_status = true, -- Display 'new file status
            path = 1, -- relative path
          },
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    },
  },
  { 'tpope/vim-fugitive' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind.nvim',
      'garymjr/nvim-snippets' ,
      'hrsh7th/cmp-nvim-lsp' ,
      'hrsh7th/cmp-buffer' ,
      'hrsh7th/cmp-nvim-lsp-document-symbol' ,
      'hrsh7th/cmp-nvim-lsp-signature-help' ,
      'ray-x/cmp-treesitter' ,
      'dmitmel/cmp-cmdline-history' ,
      { 'mtoohey31/cmp-fish', ft = "fish" },
      { url = 'https://codeberg.org/FelipeLema/cmp-async-path' },
    },
    opts = function()
      local cmp = require 'cmp'
      local defaults = require('cmp.config.default')()
      return {
        formatting = {
          format = require('lspkind').cmp_format({
            ellipsis_char = '…',
            maxwidth = function()
              return math.floor(0.45 * vim.o.columns)
            end,
            mode = 'symbol',
            show_labelDetails = true,
          })
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['C-o>'] = cmp.mapping.open_docs(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-[>'] = function(fallback)
            cmp.abort()
            fallback()
          end,
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        sorting = defaults.sorting,
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = 'cmp_yanky'},
          { name = "snippets" },
        }, {
          { name = "treesitter" },
        }, {
          { name = "buffer" },
        }),
        view =  {
          docs = {
            auto_open = true,
          },
        },
        window = {
          completion = cmp.config.window.bordered({ border = 'rounded' }),
          documentation = cmp.config.window.bordered({ border = 'rounded' }),
        },
      }
    end,
    config = function(_, opts)
      require('cmp').setup(opts)
    end,
  },
  {
    "hrsh7th/cmp-cmdline" ,
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'nvim_lsp_document_symbol' },
        },{
          { name = 'treesitter' },
        },{
          { name = 'buffer' },
        }),
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'cmdline', priority = 1000, option = { ignore_cmds = { 'Man', '!' } } },
          { name = 'cmdline_history', priority = 500 },
          { name = 'path', priority = 750 },
        })
      })
    end
  },
  {
    "garymjr/nvim-snippets",
    opts = {
      create_cmp_source = true,
    },
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
      menu = {},
    },
    enabled = vim.g.icons_enabled,
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },
}
