return {
  'navarasu/onedark.nvim',
  name = 'onedark',
  priority = 1000,
  config = function()
    require('onedark').load()
  end,
}
