require('nvim-treesitter.configs').setup {
  auto_install = false,
  ignore_install = 'all',
  -- Highlighting enabled by Rocks
  highlight = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-Space>',
      node_decremental = '<C-CR>',
      node_incremental = '<C-Space>',
      scope_incremental = false,
    }
  },
  indent = { enable = false },
  textobjects = {
    lsp_interop = {
      border = 'double',
      enable = true,
      floating_preview_opts = {},
      peek_definition_code = {},
    },
    move = {
      enable = true,
      -- Goes to whichever closer, the start or the end
      goto_next = {},
      goto_previous = {},
      goto_next_start = {},
      goto_next_end = {},
      goto_previous_start = {},
      goto_previous_end = {},
      set_jumps = true,
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {},
      include_surrounding_whitespace = false,
    },
    swap = { enable = false },
  }
}

