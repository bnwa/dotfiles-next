return {
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
}
