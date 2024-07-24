return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_check_bracket_line = false,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  {
    "cappyzawa/trim.nvim",
    event = "BufWrite",
    opts = {
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = false,
      trim_first_line = false,
      -- ft_blocklist = { "markdown", "text", "org", "tex", "asciidoc", "rst" },
      -- replace multiple blank lines with a single line
      -- patterns = {[[%s/\(\n\n\)\n\+/\1/]]},
    },
  },
  {
    'arnamak/stay-centered.nvim',
    opts = {},
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    ft = "markdown",
    opts = {},
  },
  {
    'gprod/yanky.nvim',
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
  },
  {
    "LudoPinelli/comment-box.nvim",
    opts = {
      comment_style = 'auto',
    },
  },
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
