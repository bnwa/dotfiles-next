local lsp = require 'user.utils.lsp'
local str = require 'user.utils.str'

return {
  {
    'p',
    '<Plug>(YankyPutAfter)',
    desc = 'Put register before cursor with Yanky',
  },
  {
    'P',
    '<Plug>(YankyPutBefore)',
    desc = 'Put register before cursor with Yanky',
  },
  {
    ']p',
    '<Plug>(YankyPutIndentAfterLinewise)',
    desc = "Put register after current line"
  },
  {
    ']P',
    '<Plug>(YankyPutIndentBeforeLinewise)',
    desc = "Put register before current line"
  },
  {
    '<leader>?',
    function()
      require('which-key').show {}
    end,
  },
  {
    "<leader>,",
    function() vim.cmd.nohl() end,
    desc = "Clear search highlight"
  },
  {
    "<leader>`",
    function() require('telescope.builtin').marks {} end,
    desc = "List marks and jump on selection" },
  {
    "<leader>a",
    function() vim.lsp.buf.code_action() end,
    desc = "Select available code action" },
  {
    "<leader>d",
    function() vim.lsp.buf.hover() end,
    desc = "Show LSP type information for symbol under cursor" },
  {
    "<leader>e",
    function() require('trouble').toggle 'diagnostics' end,
    desc = "Show LSP diagnostics in quickfix list" },
  {
    "<leader>f", group = "Find" },
  {
    "<leader>f'",
    function() require('telescope.builtin').registers {}
    end,
    desc = "List registers and paste on selection" },
  {
    "<leader>fD",
    function() require('telescope.builtin').lsp_type_definitions {} end,
    desc = "Find definition for type under cursor"
  },
  {
    "<leader>fO",
    function()
      local picker = require 'telescope.builtin'
      picker.lsp_dynamic_workspace_symbols {}
    end,
    desc = "Find symbol in the current workspace"
  },
  {
    '<leader>fp',
    function()
      local scope = require 'telescope'
      local picker = scope.extensions.yank_history
      picker.yank_history()
    end,
  },
  {
    "<leader>fP",
    function()
      local picker = require 'telescope.builtin'
      picker.resume {}
    end,
    desc = "Resume previous picker state"
  },
  {
    "<leader>fd",
    function() require('telescope.builtin').lsp_definitions {} end,
    desc = "Find definition for type under cursor"
  },
  { "<leader>ff",
    function()
      local picker = require 'telescope.builtin'
      if vim.loop.fs_stat('./.git') then
        picker.git_files { show_untracked = true }
      else
        picker.find_files {}
      end
    end,
    desc = "Find files under current working directory" },
  {
    "<leader>fh",
    function()
      require('telescope.builtin').help_tags {}
    end,
    desc = "Find help page via tag match"
  },
  {
    "<leader>fl",
    function()
      local picker = require 'telescope.builtin'
      picker.buffers {
        sort_mru = true,
      }
    end,
    desc = "Find buffer"
  },
  {
    "<leader>fo",
    function()
      local picker = require 'telescope.builtin'
      if vim.tbl_isempty(vim.lsp.get_clients()) then
        picker.treesitter {}
      else
        picker.lsp_document_symbols {}
      end
    end,
    desc = "Find symbol in current buffer"
  },
  {
    "<leader>fr",
    function()
      local picker = require 'telescope.builtin'
      picker.lsp_references {}
    end,
    desc = "find references to the symbol under cursor"
  },
  {
    "<leader>fs",
    function()
      if vim.fn.system({'which', 'ripgrep' }) then
        require('telescope.builtin').live_grep {}
      else
        vim.notify('Install ripgrep to use live grep')
      end
    end,
    desc = "Live grep workspace if ripgrep installed"
  },
  {
    "<leader>fu",
    function()
      local picker = require 'telescope'
      picker.extensions.undo.undo()
    end,
    desc = "View undo tree and apply changes"
  },
  { "<leader>g", group = "Go to..." },
  {
    "<leader>gd",
    function() end,
    desc = "... LSP definition"
  },
  {
    "<leader>r",
    function() vim.lsp.buf.rename() end,
    desc = "Rename symbol under cursor"
  },
  {
    "<leader>t",
    function() vim.cmd 'Git' end,
    desc = "Show Fugitive git status pane"
  },
  {
    '<leader>j',
    function()
      local ok, treesj = pcall(require, 'treesj')
      if ok then treesj.toggle() end
    end,
  },
}
