---@type LazyPluginSpec
return {
  'navarasu/onedark.nvim', -- https://github.com/navarasu/onedark.nvim
  name = 'onedark',
  priority = 1000,
  -- TODO: Fix the weird black bar at the top when a backdrop is used
  config = function()
    require('onedark').load()
  end,
}
