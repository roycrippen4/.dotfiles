---@type LazyPluginSpec
return {
  'vhyrro/luarocks.nvim',
  priority = 1001,
  opts = { rocks = { 'lua-cjson', 'http', 'magick' } },
}
