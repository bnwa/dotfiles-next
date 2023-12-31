return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function()
    local config = require 'nvim-treesitter.configs'

    config.setup {
      ensure_installed = {
        'css',
        'dockerfile',
        'fish',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'rust',
        'scss',
        'sql',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
      highlight = {
        additional_vim_regex_highlighting = false,
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn", -- set to `false` to disable one of the mappings
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
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
            ["@class.outer"] = "V",
            ["@class.inner"] = "V",
            ["@function.outer"] = "V",
            ["@function.inner"] = "V",
            ["@parameter.outer"] = "v",
            ["@parameter.inner"] = "v",
            ["@scope"] = "V",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>w"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>W"] = "@parameter.inner",
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
    }
  end,
  dependencies = {
    {'nvim-treesitter/nvim-treesitter-textobjects' }
  },
}

