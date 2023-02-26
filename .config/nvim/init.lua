local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt
local group = vim.api.nvim_create_augroup('Config', { clear = true })
local new_cmd = vim.api.nvim_create_user_rommand
local autocmd = vim.api.nvim_create_autocmd


-- OPTIONS
opt.background = 'dark'
opt.expandtab = true
opt.gdefault = true
opt.laststatus = 2
opt.number = true
opt.listchars.precedes = "«"
opt.listchars.extends = "»"
opt.relativenumber = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.shortmess:append "c"
opt.splitbelow = false
opt.splitright = false
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 500
opt.wildignore:append '/.git'
opt.wrap = false
opt.writebackup = false
opt.undofile = true
opt.updatetime = 100
opt.visualbell = false

vim.g.mapleader = ' '

--UTILS
local function toggle_night_shift()
  local date_str = os.date()
  --TODO When day component is single digit, produces a space entry in
  --resulting table so hour entry is at index 5
  local date_parts = vim.split(date_str, '[%s%p]+')
  local date_hour = fn.str2nr(date_parts[4])

  if date_hour >= 17 or date_hour < 7 then
    opt.background = 'dark'
  else
    opt.background = 'light'
  end
end


-- PLUGINS
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"

local setup_toggleterm = function()
  require('toggleterm').setup {
    direction = 'float',
    open_mapping = [[<C-\>]],
  }
end

local setup_cmp = function()
  local cmp = require('cmp')
  cmp.setup {
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args)
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'luasnip' },
      { name = 'treesitter' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline({ '/', '?', }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'treesitter' },
    }, {
      { name = 'buffer' },
    }),
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
end

local setup_telescope = function()
  local scope = require 'telescope'
  scope.setup {
    defaults = {
      dynamic_preview_title = true,
      entry_prefix = '○ ',
      layout_config = {
        preview_cutoff = 20,
      },
      layout_strategy = 'vertical',
      selection_caret = '➞ ',
      wrap_results = true,
    },
    extensions = {
      file_browser = {
        hijack_netrw = true,
      },
      fzf = {
        case_mode = 'smart_case',
        fuzzy = true,
        override_file_sorter = true,
        override_generic_sorter = true,

      },
      lazy = {
        show_icon = true,
      },
      ['ui-select'] = {
        require('telescope.themes').get_dropdown {},
      }
    },
  }
  scope.load_extension('file_browser')
  scope.load_extension('fzf')
  scope.load_extension('lazy')
  scope.load_extension('ui-select')
end

local function setup_treesitter()
  local tsitter = require 'nvim-treesitter.configs'
  tsitter.setup {
    ensure_installed = {
      'css',
      'dockerfile',
      'fish',
      'help',
      'html',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'markdown',
      'scss',
      'sql',
      'toml',
      'typescript',
      'vim',
      'yaml',
    },
    highlight = {
      additional_vim_regex_highlighting = false,
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn", -- set to `false` to disable one of the mappings
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }
end

local function setup_luapad()
  require('luapad').setup {
    eval_on_change = false
  }
end

local function setup_devicons()
  require('nvim-web-devicons').setup {}
end

if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

opt.rtp:prepend(lazypath)

require('lazy').setup {
  -- TEXT OBJECTS
  { 'nvim-treesitter/nvim-treesitter', config = setup_treesitter, build = ":TSUpdate" },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'mfussenegger/nvim-treehopper' },
  { 'tpope/vim-surround' },

  -- TERMINAL
  { 'akinsho/toggleterm.nvim', config = setup_toggleterm },

  -- AUTOCOMPLETE
  { 'hrsh7th/nvim-cmp', config = setup_cmp },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'mtoohey31/cmp-fish', ft = 'fish' },
  { 'ray-x/cmp-treesitter' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip', version = '1.x.x' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },


  -- PICKER
  -- https://github.com/nvim-telescope/telescope.nvim
  { 'nvim-telescope/telescope.nvim', tag = '0.1.1', config = setup_telescope, dependencies = { 'nvim-lua/plenary.nvim' } },
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  -- https://github.com/nvim-telescope/telescope-file-browser.nvim
  { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-lua/plenary.nvim'  } },
  -- https://github.com/nvim-telescope/telescope-ui-select.nvim
  { 'nvim-telescope/telescope-ui-select.nvim' },
  -- https://github.com/tsakirist/telescope-lazy.nvim
  { 'tsakirist/telescope-lazy.nvim' },

  -- COLORSCHEMES
  { 'ramojus/mellifluous.nvim',  dependencies = { 'rktjmp/lush.nvim' }, priority = 1000, lazy = false  },
  { 'rose-pine/neovim', name = 'rose-pine', priority = 1000, lazy = false   },
  { 'savq/melange', priority = 1000, lazy = false   },

  -- ICONS
  { 'nvim-tree/nvim-web-devicons', config = setup_devicons },

  --REPL
  { 'rafcamlet/nvim-luapad', config = setup_luapad }
}


-- NEOVIDE
if vim.g.neovide then
  opt.guifont = { 'FiraCode Nerd Font:h16',  }
  vim.g.neovide_remember_window_size = true
  cmd.colorscheme 'mellifluous'
  cmd.cd '~'
end


-- COLORS
cmd.colorscheme 'default'
toggle_night_shift()


-- KEYMAP
local function map(modes, lhs, rhs, opts)
  opts = opts and extend('force', { silent = true }, opts) or { silent = true }
  vim.keymap.set(modes, lhs, rhs, opts)
end

map('n', [[<space>f]], function()
  local picker = require 'telescope.builtin'
  if vim.loop.fs_stat('./.git') then
    picker.git_files { show_untracked = true }
  else
    picker.find_files {}
  end
end)

if fn.system({'which', 'ripgrep' }) then
  map('n', [[<space>s]], function()
    require('telescope.builtin').live_grep {}
  end)
end

map('n', [[<space>y]], function()
  require('telescope.builtin').treesitter {}
end)

map({ 'o', 'x' }, [[m]], function()
  require('tsht').nodes()
end)

map('n', [[<space>,]], function()
  cmd.nohl()
end)


-- EVENTS
local function on(match, events, listener)
  autocmd(events, {
    callback = listener,
    group = group,
    pattern = match,
  })
end

on('*', { 'FocusGained', 'FocusLost' }, toggle_night_shift)
on('*', { 'TermOpen' }, function()
  vim.wo.number = false
  vim.wo.relativenumber = false
end)
