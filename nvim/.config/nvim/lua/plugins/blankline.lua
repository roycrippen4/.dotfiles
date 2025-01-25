---@type LazyPluginSpec
return {
  'lukas-reineke/indent-blankline.nvim', -- https://github.com/lukas-reineke/indent-blankline.nvim
  main = 'ibl',
  event = 'VeryLazy',

  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = { char = '▏' },
    scope = { enabled = false },
  },
}
