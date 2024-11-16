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
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "debugloop/telescope-undo.nvim",
        config = function()
          LazyVim.on_load("telescope", function()
            local ok, err = pcall(require("telescope").load_extension, "undo")
            if not ok then
              LazyVim.warn("Failed to load telescope-undo: " .. err)
            end
          end)
        end,
      },
    },
    opts = {
      defaults = {
        dynamic_preview_title = true,
        layout_config = {
          preview_cutoff = 20,
        },
        path_display = { "truncate" },
        preview = {
          filetype_hook = function(_, buf, opts)
            if opts.ft == "bigfile" then
              local preview = require("telescope.previewers.utils")
              local msg = "File too large, enable previewing with `bigfile` filetype"
              preview.set_preview_message(buf, opts.winid, msg)
              return false
            else
              return true
            end
          end,
          treesitter = true,
        },
        wrap_results = true,
      },
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    },
    keys = {
      {
        "<leader>fu",
        function()
          require("telescope").picker.extensions.undo.undo()
        end,
        { desc = "View undo tree and apply changes" },
      },
    },
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
  }
}
