---@module "ibl"
---@type LazyPluginSpec
return {
  'lukas-reineke/indent-blankline.nvim', -- https://github.com/lukas-reineke/indent-blankline.nvim
  main = 'ibl',
  event = 'VeryLazy',
  ---@type ibl.config
  opts = {
    indent = { char = '▏' },
    scope = { enabled = false },
  },
}
