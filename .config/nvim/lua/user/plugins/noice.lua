--- @module 'lazy.types'
--- @type LazySpec
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
    },
    routes = {
      -- Commands that outputs lists that require inspection should
      -- output to 'messages' view rather than ephermeral 'mini' view
      {
        filter = {
          any = {
            { event = 'noice', kind = 'stats' },
            { event = 'msg_show', cmdline = 'ls' },
            { event = 'msg_show', cmdline = 'map' },
            { event = 'msg_show', cmdline = 'marks' },
            { event = 'msg_show', cmdline = 'command' },
            { event = 'msg_show', cmdline = 'autocmd' },
            { event = 'msg_show', cmdline = 'function' },
            { event = 'msg_show', cmdline = 'registers' },
            { event = 'msg_show', cmdline = 'TSInstallInfo' },
          },
        },
        view = 'messages'
      },
    },
    views = {
      split = {
        size = "40%"
      }
    }
  },
}
