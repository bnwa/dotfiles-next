local list = require "user.utils.list"

local function colorschemes(lazy_specs)
  return list.map(lazy_specs, function(spec)
    return vim.tbl_extend("force", spec, {
      event = { 'VeryLazy' },
    })
  end)
end

return colorschemes({
  {
    "Mofiqul/dracula.nvim",
    opts = {
      -- customize dracula color palette
      colors = {
        bg = "#282A36",
        fg = "#F8F8F2",
        selection = "#44475A",
        comment = "#6272A4",
        red = "#FF5555",
        orange = "#FFB86C",
        yellow = "#F1FA8C",
        green = "#50fa7b",
        purple = "#BD93F9",
        cyan = "#8BE9FD",
        pink = "#FF79C6",
        bright_red = "#FF6E6E",
        bright_green = "#69FF94",
        bright_yellow = "#FFFFA5",
        bright_blue = "#D6ACFF",
        bright_magenta = "#FF92DF",
        bright_cyan = "#A4FFFF",
        bright_white = "#FFFFFF",
        menu = "#21222C",
        visual = "#3E4452",
        gutter_fg = "#4B5263",
        nontext = "#3B4048",
        white = "#ABB2BF",
        black = "#191A21",
      },
      -- show the '~' characters after the end of buffers
      show_end_of_buffer = true, -- default false
      -- use transparent background
      transparent_bg = true, -- default false
      -- set custom lualine background color
      lualine_bg_color = "#44475a", -- default nil
      -- set italic comment
      italic_comment = true, -- default false
      -- overrides the default highlights with table see `:h synIDattr`
      overrides = {},
      -- You can use overrides as table like this
      -- overrides = {
      --   NonText = { fg = "white" }, -- set NonText fg to white
      --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
      --   Nothing = {} -- clear highlight of Nothing
      -- },
      -- Or you can also use it like a function to get color from theme
      -- overrides = function (colors)
      --   return {
      --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
      --   }
      -- end,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },
  {
    "savq/melange",
  },
  {
    "ramojus/mellifluous.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    opts = {
      dim_inactive = false,
      color_set = "mellifluous",
      styles = { -- see :h attr-list for options. set {} for NONE, { option = true } for option
        comments = { italic = true },
        conditionals = {},
        folds = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        markup = {
          headings = { bold = true },
        },
      },
      transparent_background = {
        enabled = false,
        floating_windows = true,
        telescope = true,
        file_tree = true,
        cursor_line = true,
        status_line = false,
      },
      flat_background = {
        line_numbers = false,
        floating_windows = false,
        file_tree = false,
        cursor_line_number = false,
      },
      plugins = {
        cmp = true,
        gitsigns = true,
        indent_blankline = true,
        nvim_tree = {
          enabled = true,
          show_root = false,
        },
        neo_tree = {
          enabled = true,
        },
        telescope = {
          enabled = true,
          nvchad_like = true,
        },
        startify = true,
      },
    },
  },
  {
    "talha-akram/noctis.nvim",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = true,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },

        highlight_groups = {
          -- Comment = { fg = "foam" },
          -- VertSplit = { fg = "muted", bg = "muted" },
        },

        before_highlight = function(group, highlight, palette)
          -- Disable all undercurls
          -- if highlight.undercurl then
          --     highlight.undercurl = false
          -- end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      })
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    opts = {
      dim_inactive_widows = true,
      enable = {
        legacy_highlights = false,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      dim_inactive = false,
      styles = {
        comments = { italic = true },
      },
    }
  },
  {
    "AstroNvim/astrotheme",
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {},
  },
})
