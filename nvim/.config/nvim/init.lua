require('core')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  require('core.bootstrap').lazy(lazypath)
end

dofile(vim.g.base46_cache .. 'defaults')
---@diagnostic disable-next-line
vim.opt.rtp:prepend(lazypath)
require('plugins')
