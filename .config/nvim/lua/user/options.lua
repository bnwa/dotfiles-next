local opt = vim.opt
local g = vim.g

g.bigfile = { lines = 10000, size = 100 * 1024 }
g.min_night_time = { 18, 30 }
g.max_night_time = { 7, 0 }
g.mapleader = ' '
g.maplocalleader = ','

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile.size
            and "bigfile"
          or nil
      end,
    },
  },
})

opt.autoindent = true -- Copy current line indent when <CR>/'o'/'O' inserted
opt.copyindent = true -- copy extant indent structure when putting new line
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.colorcolumn = "80"
opt.cmdheight = 0 -- Hide command-line unless in use
opt.confirm = true -- Confirm to save changes before exiting modified buffer 
opt.cursorline = true --Highlight the current line the cursor is on
opt.diffopt:append 'algorithm:histogram' -- Diff with histogram algo
opt.diffopt:append 'linematch:60' -- Recommend line cutoff for diff hunk
opt.expandtab = true -- <TAB> in I mode, indenting with '>'/'<' uses spaces
opt.fileencoding = 'utf-8' -- Enforce UTF-8 buffer encoding
opt.fillchars.foldopen = "" -- Open fold gutter symbol
opt.fillchars.foldopen = "" -- Closed fold gutter symbol
opt.foldenable = false
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevel = 99 -- Init bufs with all folds open
opt.foldmethod = 'expr'
opt.guicursor = { 'n:blinkon200', 'i-ci-ve:ver25' } -- Enable cursor blink
opt.ignorecase = true -- Ignore case in search, command-line completion
opt.laststatus = 3 -- Enable single, global status line 
opt.listchars.extends = '»' -- Show this char when line excedes window right
opt.listchars.precendes = '«' -- Show this char when line excedes window left
opt.number = true -- Show line numbers
opt.mousescroll.hor = 1 -- Disable horizontal mouse scroll
opt.mousescroll.ver = 1 -- Scroll 1 line per mouse wheel tick
opt.hlsearch = false
opt.preserveindent = true -- Preserve indent structure when indenting line
opt.relativenumber = true -- Show relative line numbers outside current line
--opt.selection = 'old' -- v$ won't extend to newline symbol
opt.shada = "!,h,'1000,<50,s10" -- Configure shada file
opt.shell = '/opt/homebrew/bin/fish'
opt.shiftwidth = 2 -- Value of indent ops
opt.shortmess:append 'C' -- Disable tag search messages
opt.shortmess:append 'I' -- Disable intro message
opt.shortmess:append 'c' -- Disable search navigation messages
opt.shortmess:append 's' -- Disable search end messages
opt.smartcase = true -- Ignore 'ignorecase' when using upper case chars
opt.smoothscroll = true -- Enable smooth scrolling
opt.softtabstop = 2 -- Value of <TAB> in spaces
opt.termguicolors = true -- Enable True Color support
opt.undofile = true -- Enable persistent per file undo history
opt.updatetime = 4000 -- interval in milliseconds of inactivity to write swap
opt.updatecount = 200 -- Number of characters typed at which to write swap
opt.winminwidth = 10 -- Mininum window width
opt.wrap = false -- Whether to wrap lines at window boundary

if vim.g.neovide then
  vim.g.neovide_theme = 'auto' -- Neovide will manage light/dark mode
  vim.g.neovide_remember_window_size = true
  cmd.cd '~'
end
