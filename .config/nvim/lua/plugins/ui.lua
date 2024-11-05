--- @type LazySpec[]
return {
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
}
