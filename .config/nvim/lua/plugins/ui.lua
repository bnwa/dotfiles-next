--- @type LazySpec[]
return {
  { 'akinsho/bufferline.nvim', enabled = false },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      direction = "float",
      float_opts = {
        border = "double",
        title_pos = "center",
      },
      open_mapping = [[<c-\>]],
    },
    -- stylua: ignore start
    keys = {
      {
        [[<c-/>]],
        function() vim.cmd("ToggleTerm dir=" .. vim.fn.fnamemodify("%", "p:h")) end,
        desc = "Toggle floating terminal on current file's directory",
        mode = { 'n', 't' }
      },
      {
        [[<c-\>]],
        function() vim.cmd "ToggleTerm" end,
        desc = "Toggle floating terminal on current working directory",
        mode = { 'n', 't' }
      }
    },
    -- stylua: ignore end
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      sections = {
        lualine_b = {
          { 'branch',
            --- @param str string
            --- @return string
            fmt = function(str)
              if str:len() > 16 then return str:sub(1, 16)
              else return str end
            end
          }
        }
      }
    }
  },
  {
    'folke/snacks.nvim',
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      picker = {
        sources = {
          lsp_symbols = {
            filter = {
              default = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
                "Variable",
              }
            }
          }
        }
      }
    }
  },
}
