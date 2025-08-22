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
      "folke/snacks.nvim",              -- optional
    },
    ---@module 'neogit'
    ---@type NeogitConfig
    opts = {
      graph_style = 'unicode',
      integrations = {
        diffview = true,
        fzf_lua = false,
        snacks = true,
        mini_pick = false,
        telescope = false,
      }
    }
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        layout = {
          cycle = true,
          fullscreen = true,
        },
        sources = {
          diagnostics = {
            win = {
              list = {
                wo = {
                  wrap = true,
                }
              }
            }
          },
          diagnostics_buffer = {
            win = {
              list = {
                wo = {
                  wrap = true,
                }
              }
            }
          },
          explorer = {
            jump = {
              close = true,
            },
            layout = {
              cycle = true,
              fullscreen = true,
              preset = nil,
              preview = true,
            },
            win = {
              list = {
                keys = {
                  ["<BS>"] = "explorer_up",
                  ["l"] = "confirm",
                  ["h"] = "explorer_close", -- close directory
                  ["a"] = "explorer_add",
                  ["d"] = "explorer_del",
                  ["r"] = "explorer_rename",
                  ["c"] = "explorer_copy",
                  ["m"] = "explorer_move",
                  ["o"] = "explorer_open", -- open with system application
                  ["P"] = "toggle_preview",
                  ["y"] = { "explorer_yank", mode = { "n", "x" } },
                  ["p"] = "explorer_paste",
                  ["u"] = "explorer_update",
                  ["<c-c>"] = "tcd",
                  ["<leader>/"] = "picker_grep",
                  ["<c-t>"] = "terminal",
                  ["."] = "explorer_focus",
                  ["I"] = "toggle_ignored",
                  ["H"] = "toggle_hidden",
                  ["Z"] = "explorer_close_all",
                  ["]g"] = "explorer_git_next",
                  ["[g"] = "explorer_git_prev",
                  ["]d"] = "explorer_diagnostic_next",
                  ["[d"] = "explorer_diagnostic_prev",
                  ["]w"] = "explorer_warn_next",
                  ["[w"] = "explorer_warn_prev",
                  ["]e"] = "explorer_error_next",
                  ["[e"] = "explorer_error_prev",
                },
              },
            },
          },
        },
        ui_select = true,
      }
    },
    keys = {
      { '<leader>ff',
        function() Snacks.picker.files() end,
        desc = "Find a file beneath CWD"
      },
      { '<leader>fF',
        function() Snacks.picker.files() end,
        desc = "Find a file beneath CWD"
      },
      { '<leader>fl',
        function()
          Snacks.picker.buffers {
            win = {
              input = {
                keys = {
                  ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                },
              },
              list = { keys = { ["dd"] = "bufdelete" } },
            },
          }
        end,
        desc = "Find a visible buffer"
      },
      { '<leader>e',

      },
      { '<leader>l`',
        function() Snacks.picker.marks() end,
        desc = "List and select from marks"
      },
      { '<leader>l:',
        function() Snacks.picker.command_history {} end,
        desc = "List and select from command history"
      },
      { '<leader>l"',
        function() Snacks.picker.registers {} end,
        desc = "List and select from registers"
      },
      { '<leader>l/',
        function() Snacks.picker.search_history {} end,
        desc = "List and select from search history"
      },
      { '<leader>lc',
        function() Snacks.picker.colorschemes() end,
        desc = "List and select from colorschemes"
      },
      { '<leader>lh',
        function() Snacks.picker.help() end,
        desc = "List and select from help files"
      },
      {
        '<leader>lo',
        function() Snacks.picker.jumps() end,
        desc = "Search jump list and jump to selected on <Enter>"
      },
      {
        '<leader>lu',
        function() Snacks.picker.undo() end,
        desc = "List and select from undo history"
      },
      { '<leader>ss',
        function() Snacks.picker.grep() end,
        desc = "Live grep at project scope"
      },
      {
        '<leader>z',
        function() Snacks.picker.resume() end,
        desc = "Resume most recent picker instance"
      },
    },
  },
  {
    'saghen/blink.cmp',
    version = '*',
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
        default = { 'lsp', 'path', 'snippets' },
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
        -- TODO Update mellifluous highlights so that codecompanion
        -- doesn't look ridiculous when bg=light
        ignore_buftypes = { 'nofile' },
        max_buf_lines = 10000,
      },
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
          {'branch',
            fmt = function(str, _)
              return string.sub(str, 1, 25)
            end
          },
          'diff',
          { 'diagnostics',
            colored = true,
            sources = { 'nvim_lsp' }
          }
        },
        lualine_c = {
          { 'filename',
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
  },
  {
    'Bekaboo/dropbar.nvim',
    opts = {
      bar = {
        enable = function(buf, win, _)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.bo[buf].buftype ~= ''
            or vim.fn.win_gettype(win) ~= ''
            or vim.wo[win].winbar ~= ''
            or vim.bo[buf].ft == 'help'
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return vim.bo[buf].ft == 'markdown'
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = vim.lsp.protocol.Methods.textDocument_documentSymbol,
            }))
        end,
      }
    }
  }
}
