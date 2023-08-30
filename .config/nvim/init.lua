local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local extend = vim.tbl_extend
local group = vim.api.nvim_create_augroup('Config', { clear = true })
local cmd = vim.cmd
local opt = vim.opt
local fn = vim.fn


--[[
TODO Rebind motions/text objects meant for
prose for more appropriate uses in coding
context, see :h object-motions, specifically
sentence/paragraph/section types
--]]


-- OPTIONS
opt.background = 'dark'
opt.expandtab = true
opt.gdefault = true
opt.laststatus = 2
opt.number = true
opt.listchars.precedes = "«"
opt.listchars.extends = "»"
opt.relativenumber = true
if jit.arch == 'x64' then
  opt.shell = "/usr/local/bin/fish -l"
else
  opt.shell = "/opt/homebrew/bin/fish -l"
end
opt.shortmess:append "c"
opt.splitbelow = false
opt.splitright = false
opt.swapfile = false
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

  --TODO How to auto adjust for daylight savings?
  if date_hour >= 20 or date_hour < 7 then
    opt.background = 'dark'
  else
    opt.background = 'light'
  end
end

local function set(modes, lhs, rhs, opts)
  opts = opts and extend('force', { silent = true }, opts) or { silent = true }
  keymap(modes, lhs, rhs, opts)
end

local function on(match, events, listener)
  autocmd(events, {
    callback = listener,
    group = group,
    pattern = match,
  })
end


-- EVENTS
on('*', { 'FocusGained', 'FocusLost' }, toggle_night_shift)
on('*', { 'TermOpen' }, function()
  vim.wo.number = false
  vim.wo.relativenumber = false
end)


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
        require('luasnip').lsp_expand(args.body)
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
      },
      undo = {
        side_by_side = true,
        layout_strategy = 'vertical',
        layout_config = {
          preview_height = 0.8,
        },
      },
    },
  }
  scope.load_extension('file_browser')
  scope.load_extension('fzf')
  scope.load_extension('lazy')
  scope.load_extension('ui-select')
  scope.load_extension('undo')
end

local function setup_treesitter()
  local tsitter = require 'nvim-treesitter.configs'
  tsitter.setup {
    ensure_installed = {
      'css',
      'dockerfile',
      'fish',
      'html',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'markdown',
      'rust',
      'scss',
      'sql',
      'toml',
      'typescript',
      'vim',
      'vimdoc',
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

local function setup_tokyonight()
  require('tokyonight').setup {
    style = 'night'
  }
end

local function setup_devicons()
  require('nvim-web-devicons').setup {}
end

local function setup_mason()
  local mason = require 'mason'
  local registry = require 'mason-registry'
  local ensure_installed = {
    'jdtls',
    'json-lsp',
    'lemminx',
    'lua-language-server',
    'typescript-language-server',
  }

  mason.setup {
    PATH = 'prepend',
    ui = {
      border = 'shadow',
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      }
    }
  }

  -- Install servers that're ensured and reload ftplugin
  -- if no LSP client attached to current buffer
  for _, server in ipairs(ensure_installed) do
    if not registry.is_installed(server) then
      cmd { cmd = 'MasonInstall' , args = { server } }
    end
  end

  if #vim.lsp.get_active_clients({ buffer = 0 }) == 0 then
    cmd { cmd = 'filetype', args = { 'detect' } }
  end
end

local function setup_lsp_lines()
  require('lsp_lines').setup()
end

local function setup_neodev()
  require('neodev').setup {
    lspconfig = false,
    setup_jsonls = false,
  }
end

local function setup_which_key()
  local which_key = require 'which-key'
  which_key.setup {
    marks = false,
    registers = false,
    window = {
      winblend = 5,
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
          cmd.nohl()
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
      e = {
        function()
          vim.diagnostic.setqflist()
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
            if vim.lsp.buf.server_ready() then
              picker.lsp_document_symbols {}
            else
              picker.treesitter {}
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
            if fn.system({'which', 'ripgrep' }) then
              require('telescope.builtin').live_grep {}
            else
              vim.notify('Install ripgrep to use live grep')
            end
          end,
          "Live grep workspace if ripgrep installed",
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

local function setup_rosepine()
  require('rose-pine').setup {
    variant = 'auto',
    dark_variant = 'moon',
    bold_vert_split = true,
    disable_italics = true,
  }
end

local function setup_bqf()
  require('bqf').setup  {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      wrap = true,
    },
  }
end

local function setup_gruvbox()
  require('gruvbox').setup {}
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
  { 'nvim-telescope/telescope.nvim', tag = '0.1.1', config = setup_telescope,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
      { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-lua/plenary.nvim'  } },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'tsakirist/telescope-lazy.nvim' },
      { 'debugloop/telescope-undo.nvim' },
    }
  },

  -- COLORSCHEMES
  { 'ramojus/mellifluous.nvim',  dependencies = { 'rktjmp/lush.nvim' } },
  { 'rose-pine/neovim', name = 'rose-pine', config = setup_rosepine },
  { 'savq/melange' },
  { 'folke/tokyonight.nvim', config = setup_tokyonight },
  { 'ellisonleao/gruvbox.nvim', config = setup_gruvbox },
  { 'illotum/flat.nvim' },
  { 'talha-akram/noctis.nvim' },

  -- ICONS
  { 'nvim-tree/nvim-web-devicons', config = setup_devicons },

  --REPL
  { 'rafcamlet/nvim-luapad', config = setup_luapad },

  -- LANGUAGE TOOLING
  { 'williamboman/mason.nvim', config = setup_mason },
  { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', config = setup_lsp_lines },
  { 'folke/neodev.nvim', config = setup_neodev },
  { 'mfussenegger/nvim-jdtls' },
  { 'b0o/schemastore.nvim' },
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = { previewer_cmd = 'glow' }
  },

  { 'folke/which-key.nvim', config = setup_which_key, },
  { 'kevinhwang91/nvim-bqf', config = setup_bqf, ft = 'qf', },
}

-- Keymaps
set('n', 'j', 'gj') -- down/up treats wrapped lines as single lines
set('n', 'k', 'gk')
set('n', 'p', ']p') -- putting text should match destination indent
set('n', 'P', ']P')
set('n', '<C-J>', '<C-W><C-J>') -- use one chord to switch pane focus
set('n', '<C-K>', '<C-W><C-K>')
set('n', '<C-L>', '<C-W><C-L>')
set('n', '<C-H>', '<C-W><C-H>')


-- COLORS
cmd.colorscheme 'tokyonight'
toggle_night_shift()


-- NEOVIDE
if vim.g.neovide then
  opt.guifont = { 'FiraCode Nerd Font:h16',  }
  vim.g.neovide_remember_window_size = true
  cmd.colorscheme 'mellifluous'
  cmd.cd '~'
end

