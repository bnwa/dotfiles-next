local list = require 'config.utils.list'
---@module 'lazy'
---@type LazySpec[]
return list.flatten {
  require('config.filetypes.css'),
  require('config.filetypes.dockerfile'),
  require('config.filetypes.fish'),
  require('config.filetypes.html'),
  require('config.filetypes.java'),
  require('config.filetypes.json'),
  require('config.filetypes.lua'),
  require('config.filetypes.sh'),
  require('config.filetypes.typescript'),
  require('config.filetypes.xml'),
  require('config.filetypes.yaml'),
  require('config.filetypes.zsh'),
}
