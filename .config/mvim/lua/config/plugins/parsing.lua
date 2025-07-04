--- @module 'lazy'
--- @type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'OXY2DEV/markview.nvim',
    },
    lazy = false,
    build = ":TSUpdateSync",
    main = 'nvim-treesitter.configs',
    ---@module 'nvim-treesitter'
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      auto_install = true,
      sync_install = false,
      highlight = {
        additional_vim_regex_highlighting = false,
        ---@diagnostic disable-next-line:unused-local
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>', -- set to `false` to disable one of the mappings
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<C-BS>',
        },
      },
      indent = {
        enable = true,
      },
    }
  },
  {
    dir = 'user.settings',
    optional = true,
    virtual = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    opts = {
      foldexpr = 'nvim_treesitter#foldexpr()',
      foldmethod = 'expr',
    },
  },
}
