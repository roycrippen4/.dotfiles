---@type LazyPluginSpec
return {
  'navarasu/onedark.nvim', -- https://github.com/navarasu/onedark.nvim
  name = 'onedark',
  priority = 1000,
  config = function()
    require('onedark').load()
  end,
}
