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
    messages = {
      view = "messages",
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
    },
    routes = {
      -- JDTLS emits progress as message
      {
        filter = {
          event = 'msg_show',
          find = 'Language Server',
        },
        view = 'mini',
      },
      -- JDTLS announces server online as message
      {
        filter = {
          event = 'msg_show',
          find = '%s*Ready$',
        },
        view = 'mini',
      },
      -- JDTLS announces startup as message
      {
        filter = {
          event = 'msg_show',
          find = '^Init',
        },
        view = 'mini',
      },
      -- NoiceStats flashes as 'mini' view by default, ugh...
      {
        filter = {
          event = 'noice',
          kind = 'stats',
        },
        view = 'messages',
      },
    },
    views = {
      split = {
        size = "40%"
      }
    }
  },
}
