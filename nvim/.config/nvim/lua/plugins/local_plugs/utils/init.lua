require('plugins.local_plugs.utils.general')
local C = require('plugins.local_plugs.utils.compare')
local M = {}

return vim.tbl_extend('error', M, C)
