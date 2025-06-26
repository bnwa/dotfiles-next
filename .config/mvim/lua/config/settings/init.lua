---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = 'user.settings',
    virtual = true,
    event = 'VeryLazy',
    opts = {},
    config = function(_, opts)
      for opt, value in pairs(opts) do
        vim.opt[opt] = value
      end
    end
  },
  {
    dir = 'user.filetypes',
    virtual = true,
    opts = {},
    config = function()
      local autocmd = require 'config.utils.autocmd'
      local fts = {
        'dockerfile',
        'fish',
        'html',
        'java',
        'sh',
        'xml',
        'zsh',
      }
      autocmd.filetype(fts, function()
          vim.bo.ts = 4
          vim.bo.sw = 4
      end)
    end
  },
  {
    dir = 'user.colorscheme',
    virtual = true,
    event = 'VeryLazy',
    config = function()
      local colorscheme = vim.g.colorscheme
      if not pcall(vim.cmd.colorscheme, colorscheme) then
        local msg = 'Failed to load colorscheme: ' .. colorscheme
        local chunks = {{ msg, 'ErrorMsg' }}
        vim.api.nvim_echo(chunks, true, {})
      end

      if vim.g.neovide then
        vim.g.neovide_theme = 'auto' -- Neovide will manage light/dark mode
      else
        vim.schedule(function()
          local autocmd = require 'config.utils.autocmd'
          local platform = require 'config.utils.platform'
          local function light_or_dark_mode()
            local ok, mode = platform.exec {
              'defaults', 'read', '-g', 'AppleInterfaceStyle'
            }
            if not ok then
              vim.opt.background = 'light'
            elseif vim.trim(mode) == 'Dark' then
              vim.opt.background = 'dark'
            end
          end
          light_or_dark_mode()
          autocmd.event("Toggle background when focus changes",
            { 'FocusGained', 'FocusLost' },
            { '*' },
            light_or_dark_mode)
        end)
      end
    end,
  },
  {
    dir = 'user.autocmds',
    event = 'VeryLazy',
    virtual = true,
    config = function()
      local autocmd = require 'config.utils.autocmd'

      autocmd.filetype({'help', 'qf'}, function()
        vim.keymap.set('n', 'q', function() vim.cmd 'close' end, { buffer = true })
      end)

      autocmd.event("Resize splits if window is resized",
        {'VimResized'}, {'*'}, function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end)

      autocmd.event('Jump to last cursor position on initial open',
        {'BufReadPost'}, {'*'}, function(args)
          local buf = args.buf
          if vim.b[buf].did_open then return end
          vim.b[buf].did_open = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end)

      -- Auto create dir when saving a file, in case some intermediate directory does not exist
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        group = autocmd.AUGROUP,
        callback = function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end,
      })

    -- Set global variable to detect an open/closed quickfix window
    vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = { 'qf' },
        callback = function(data)
          local win = vim.api.nvim_get_current_win()
          vim.g.is_qf_open = true
          vim.api.nvim_create_autocmd({'WinClosed'}, {
            once = true,
            pattern = {'' .. win},
            callback = function(args)
              vim.print(args, win)
              vim.g.is_qf_open = false
            end
          })
        end
      })

      -- Fix bizarre avante default behavior with weird operator pending mode issue
      -- https://github.com/yetone/avante.nvim/issues/902#issuecomment-2994345221
      vim.api.nvim_create_autocmd("WinEnter", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype == "AvanteInput" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", false)
            vim.cmd("startinsert")
          end
        end,
      })
    end
  },
}
