local path = require 'config.utils.path'

---@module 'lazy'
---@type LazySpec[]
return {
  -- Icons
  {
    'echasnovski/mini.icons',
    version = false,
    opts= {},
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  -- UI router for messages and notifications
  {
    'folke/noice.nvim',
    dependencies = {
      "MunifTanjim/nui.nvim"
    },
    ---@module 'noice'
    ---@type NoiceConfig
    ---@diagnostic disable-next-line:missing-fields
    opts = {
      cmdline = {
        enabled = true,
      },
      lsp = {
        progress = {
          enabled = true
        },
        hover = {
          enabled = false
        },
        signature = {
          enabled = false
        },
        message = {
          enabled = true
        },
        documentation = {
          enabled = false
        }
      },
      messages = {
        enabled = true
      },
      notify = {
        enabled = true
      },
      popupmenu = {
        enabled = true
      },
      presets = {
        command_palette = true
      },
      routes = {
        {
          filter = {
            cmdline = true,
            ['not'] = {
              any = {
                { cmdline = 'wq?a?' },-- write msgs
                { find = '^E%d+' },-- error msg
                { cmdline = '^/' }, -- search input
              }
            }
          },
          view = 'messages'
        },
        {
          filter = {
            any = {
              { cmdline = '^/' },
              { find = '^/' },
            }
          },
          opts = { skip = true }
        },
      },
    }
  },
  -- magit-inspired git UI
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "ibhagwan/fzf-lua",              -- optional
    },
    ---@module 'neogit'
    ---@type NeogitConfig
    opts = {
      graph_style = 'unicode',
      integrations = {
        diffview = true,
        fzf_lua = true,
        mini_pick = false,
        telescope = false,
      }
    }
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      -- Keeps fzf process running in bg on UI close
      'hide',
      defaults = {
        file_icons = 'mini',
      },
      fzf_colors = true,
      fzf_opts = {
        ['--cycle'] = true,
        ['--keep-right'] = true,
      },
    },
    keys = {
      {
        '<leader>fa',
        function() require('fzf-lua').args {} end,
        desc = "Find files in arguments list"
      },
      { '<leader>ff',
        function()
            require('fzf-lua').files {}
        end,
        desc = "Find files beneath CWD"
      },
      { '<leader>fF',
        function() require('fzf-lua').files {} end,
        desc = "Find files beneath CWD"
      },
      { '<leader>fl',
        function() require('fzf-lua').buffers {} end,
        desc = "Find open buffers"
      },
      { '<leader>fh',
        function() require('fzf-lua').helptags {} end,
        desc = "Search Vim help files"
      },
      { '<leader>sg',
        function() require('fzf-lua').live_grep { multiprocess = true } end,
        desc = "Live grep at project scope"
      },
      { '<leader>ss',
        function() require('fzf-lua').treesitter {} end,
        desc = "Search symbols in the current buffer via Treesitter"
      },
      {
        '<leader>sb',
        function() require('fzf-lua').git_blame {} end,
        desc = "Query 'git blame' output for current buffer"
      },
      {
        '<leader>sO',
        function() require('fzf-lua').jumps {} end,
        desc = "Search jump list and jump to selected on <Enter>"
      },
      {
        '<leader>svh',
        function() require('fzf-lua').git_hunks {} end,
        desc = "Git hunks",
      },
      {
        '<leader>svb',
        function() require('fzf-lua').git_branches {} end,
        desc = "Git branches",
      },
      {
        '<leader>svL',
        function() require('fzf-lua').git_commits {} end,
        desc = "Project Git log",
      },
      {
        '<leader>svl',
        function() require('fzf-lua').git_bcommits {} end,
        desc = "Buffer Git log",
      },
      {
        '<leader>z',
        function() require('fzf-lua').resume() end,
        desc = "Resume most recent Fzf instance"
      },
    },
  },
  {
    'saghen/blink.cmp',
    version = '*',
    dependencies = { 'Kaiser-Yang/blink-cmp-avante' },
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },
        keyword = {
          range = 'full',
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
      },
      signature = { enabled = true },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'avante','lsp', 'path', 'snippets' },
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {}
          }
        },
      },
      keymap = {
        preset = 'enter',
      },
      cmdline = {
        enabled = false,
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    event = { 'VeryLazy' },
    opts_extend = {'preview.filetypes'},
    ---@module 'markview.nvim'
    ---@type markview.config
    opts = {
      preview = {
        -- plugin default
        filetypes = { "markdown", "rmd", "quarto", "typst" },
        icon_provider = 'mini',
        max_buf_lines = 10000,
      },
    },
  },
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'echasnovski/mini.icons' },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      default_file_explorer = true,
      delete_to_trash = true,
      git = {
        add = function(path) return true end,
        mv = function(src_path, dest_path) return true end,
        rm = function(path) return true end,
      },
      lsp_file_methods = {
        autosave_changes = true,
      },
      preview_win = {
        disable_preview = function(filename)
          local is_log = string.match(filename, 'log') ~= nil
          if is_log then return false
          else return true end
        end,
      },
    },
    keys = {
      {
        '<leader>ee',
        function()
          require('oil').toggle_float(vim.fn.getcwd())
        end,
        desc = "Open Oil file explorer on CWD"
      },
      {
        '<leader>eb',
        function()
          local buf = vim.api.nvim_get_current_buf()
          local path = vim.api.nvim_buf_get_name(buf)
          require('oil').toggle_float(vim.fn.fnamemodify(path, ':p:h'))
        end,
        desc = "Open Oil file explorer on CWD"
      }
    },
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

   "lukas-reineke/virt-column.nvim",
    opts = {
      char = "▕",
      virtcolumn = '66'
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'echasnovski/mini.icons',
    },
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        globalstatus = true,
        ignore_focus = {
          'netrw',
        },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          'mode'
        },
        lualine_b = {
          {'branch', fmt = function(str, ctx)
            return string.sub(str, 1, 25)
          end},
          'diff',
          { 'diagnostics', colored = true, sources = { 'nvim_lsp' } }
        },
        lualine_c = {
          {
            'filename',
            newfile_status = true, -- Display 'new file status
            path = 1, -- relative path
          },
        },
        lualine_x = {
          'searchcount',
          function ()
            local status = require 'lazy.status'
            if status.has_updates() then
              return status.updates()
            else
              return ''
            end
          end,
          'encoding',
          'fileformat',
          {'filetype', colored = false, }
        },
        lualine_y = {
          'progress'
        },
        lualine_z = {
          'location'
        },
      },
    }
  },
  {
    "yarospace/lua-console.nvim",
    ft = { 'lua' },
    opts = {
      clear_before_eval = true,
      mappings = {
        attach = [[<leader>\a]],
        kill_ps = [[<leader>\q]],
        toggle = [[<leader>\\]],
      },
      preserve_context = false,
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module 'which-key.config'
    ---@type wk.Opts
    opts = {
      plugins = {
        spelling = {
          enabled = false,
        }
      },
      preset = 'helix',
      spec = {
        { '<leader>a', icon = '', group = "Assistance", desc = 'LLM provided assistance' },
        { '<leader>c', icon = '', group = "LSP Actions", desc = 'LSP provided assistance' },
        { '<leader>e', icon = '󰙅', group = "Explorer", desc = 'Manually traverse file system' },
        { '<leader>g', icon = '', group = "Traversals", desc = "Traverse various project relationships" },
        { '<leader>f', icon = '󰱼', group = "Files", desc = "Text search and semantic queries"},
        { '<leader>s', icon = '', group = "Query", desc = "Text search and semantic queries"},
        { '<leader>sv', icon = '󰊢', group = 'Git Search', desc = "Search Git objects"},
        { '<leader>x', icon = '', group = "Debugging", desc = "Diagnostics and debugging" },
      }
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  }
}
