return {
  'folke/which-key.nvim',
  config = function()
    local which_key = require 'which-key'

    which_key.setup {
      plugins = {
        spelling = {
          enabled = false,
        },
      },
      popup_mappings = {
        scroll_down = '<c-d>',
        scroll_up = '<c-u>',
      },
      window = {
        border = 'shadow',
      },
    }

    which_key.register {
      ['<leader>'] = {
        ['`'] = {
          function()
            local picker = require 'telescope.builtin'
            picker.marks {}
          end,
          "List marks and jump on selection"
        },
        [','] = {
          function()
            vim.cmd.nohl()
          end,
          "Clear search highlight"
        },
        a = {
          function()
            vim.lsp.buf.code_action()
          end,
          "Select available code action"
        },
        d = {
          function()
            vim.lsp.buf.hover()
          end,
          "Show LSP type information for symbol under cursor"
        },
        E = {
          function()
            require('trouble').toggle 'workspace_diagnostics'
          end,
          "Show LSP diagnostics in quickfix list"
        },
        e = {
          function()
            require('trouble').toggle 'document_diagnostics'
          end,
          "Show LSP diagnostics in quickfix list"
        },
        f = {
          name = 'Find',
          ["'"] = {
            function()
              local picker = require 'telescope.builtin'
              picker.registers {}
            end,
            "List registers and paste on selection"
          },
          D =  {
            function()
              local picker = require 'telescope.builtin'
              picker.lsp_type_definitions()
            end,
            "Find definition for type under cursor",
          },
          d =  {
            function()
              local picker = require 'telescope.builtin'
              picker.lsp_definitions()
            end,
            "Find definition for type under cursor",
          },
          f =  {
            function()
              local picker = require 'telescope.builtin'
              if vim.loop.fs_stat('./.git') then
                picker.git_files { show_untracked = true }
              else
                picker.find_files {}
              end
            end,
            "Find files under current working directory",
          },
          h = {
            function()
              require('telescope.builtin').help_tags {}
            end,
            "Find help page via tag match",
          },
          l =  {
            function()
              local picker = require 'telescope.builtin'
              picker.buffers {
                sort_mru = true,
              }
            end,
            "Find buffer",
          },
          O =  {
            function()
              local picker = require 'telescope.builtin'
              picker.lsp_dynamic_workspace_symbols {}
            end,
            "Find symbol in the current workspace",
          },
          o =  {
            function()
              local picker = require 'telescope.builtin'
              if vim.tbl_isempty(vim.lsp.get_clients()) then
                picker.treesitter {}
              else
                picker.lsp_document_symbols {}
              end
            end,
            "Find symbol in current buffer",
          },
          P = {
            function()
              local picker = require 'telescope.builtin'
              picker.resume {}
            end,
            "Resume previous picker state",
          },
          r =  {
            function()
              local picker = require 'telescope.builtin'
              picker.lsp_references {}
            end,
            "find references to the symbol under cursor",
          },
          u =  {
            function()
              local picker = require 'telescope'
              picker.extensions.undo.undo()
            end,
            "View undo tree and apply changes",
          },
          s = {
            function()
              if vim.fn.system({'which', 'ripgrep' }) then
                require('telescope.builtin').live_grep {}
              else
                vim.notify('Install ripgrep to use live grep')
              end
            end,
            "Live grep workspace if ripgrep installed",
          },
        },
        g = {
          name = "Go to...",
          ['d'] =  {
            function()end,
            "... definition",
          },
        },
        t = {
          function()
            vim.cmd 'Git'
          end,
          "Show Fugitive git status pane",
        },
        r = {
          function()
            vim.lsp.buf.rename()
          end,
          "Rename symbol under cursor"
        },
      }
    }
  end
}
