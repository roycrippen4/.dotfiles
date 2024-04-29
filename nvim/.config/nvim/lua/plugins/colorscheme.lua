return {
  'navarasu/onedark.nvim',
  name = 'onedark',
  priority = 1000,
  opts = {},
  config = function()
    require('onedark').load()
  end,
}
