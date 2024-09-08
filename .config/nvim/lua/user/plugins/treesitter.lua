local fn = vim.fn
local g = vim.g

return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'andymass/vim-matchup',
    },
    build = ":TSUpdateSync",
    opts_extend = { 'ensure_installed' },
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
        'kdl',
        'kotlin',
        'lua',
        'luadoc',
        'markdown',
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
      endwise = {
        enable = true,
      },
      highlight = {
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf)
          local max_kbs = g.bigfile.size
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
        },
        matchup = {
          enable = true,
        }
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
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
    opts = {},
  },
  {
    'Wansmer/treesj',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }, -- if you install parsers with `nvim-treesitter`
    opts = {
      use_default_keymaps = false,
    },
  },
  {
      'ckolkey/ts-node-action',
       dependencies = { 'nvim-treesitter' },
       opts = {},
  },
}
