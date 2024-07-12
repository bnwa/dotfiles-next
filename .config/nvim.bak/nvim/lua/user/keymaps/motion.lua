local keymap = require 'lua.user.utils.keymap'
local nmap = keymap.nmap

-- down/up treats wrapped lines as single lines
nmap('n', 'j', 'gj')
nmap('n', 'k', 'gk')
-- putting text should match destination indent
nmap('n', 'p', ']p')
nmap('n', 'P', ']P')
-- use one chord to switch pane focus
nmap('n', '<C-J>', '<C-W><C-J>')
nmap('n', '<C-K>', '<C-W><C-K>')
nmap('n', '<C-L>', '<C-W><C-L>')
nmap('n', '<C-H>', '<C-W><C-H>')
