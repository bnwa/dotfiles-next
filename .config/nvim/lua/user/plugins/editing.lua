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
}
