---@type LazyPluginSpec
return {
  'hiphish/rainbow-delimiters.nvim', --- https://github.com/HiPhish/rainbow-delimiters.nvim
  event = 'VimEnter',
  config = function()
    require('rainbow-delimiters.setup').setup({
      strategy = {
        [''] = require('rainbow-delimiters').strategy['global'],
        vim = require('rainbow-delimiters').strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
      },
      priority = {
        [''] = 110,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    })
  end,
}
