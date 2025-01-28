---@module 'lazydev'
---@type LazyPluginSpec
return {
  'folke/lazydev.nvim', -- https://github.com/folke/lazydev.nvim
  ft = 'lua',
  ---@type lazydev.Config
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      'lazy.nvim',
      'snacks.nvim',
    },
  },
}
