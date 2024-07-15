local opt = vim.opt
local fn = vim.fn
local g = vim.g

return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = {
      "TSBufDisable",
      "TSBufEnable",
      "TSBufToggle",
      "TSDisable",
      "TSEnable",
      "TSToggle",
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSModuleInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
    },
    opts = {
      auto_install = false,
      ensure_installed = {
        'bash',
        'css',
        'editorconfig',
        'dockerfile',
        'fish',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'haskell',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'kdl',
        'kotlin',
        'lua',
        'markdown_inline',
        'purescript',
        'python',
        'ruby',
        'rust',
        'scala',
        'scss',
        'sql',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
        'zig',
      },
      highlight = {
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          local max_kbs = g.big_file.size
          local buf_name = vim.api.nvim_buf_get_name(buf)
          local ok, stats = pcall(vim.uv.fs_stat, buf_name)
          if ok and stats and stats.size > max_kbs then
            return true
          end
        end,
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>', -- set to `false` to disable one of the mappings
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<C-CR>',
        },
      },
      textobjects = {
        lsp_interop = {
          enable = false,
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["as"] = "@scope",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
          selection_modes = {
            ["@class.outer"] = "v",
            ["@class.inner"] = "v",
            ["@function.outer"] = "v",
            ["@function.inner"] = "v",
            ["@parameter.outer"] = "v",
            ["@parameter.inner"] = "v",
            ["@scope"] = "v",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>w"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>w"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next = {
            ["]f"] = { query = { "@function.outer", "@method_definition" } },
          },
          goto_previous = {
            ["[f"] = { query = { "@function.outer", "@method_definition" } },
          },
        }
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    opts =  {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false , -- Auto close on trailing </
      },
      per_filetype = {},
    }
  },
  {
    'folke/ts-comments.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    enabled = fn.has('nvim-0.10.0') == 1 ,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}
