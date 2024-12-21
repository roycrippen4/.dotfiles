---@type LazyPluginSpec
return {
  'folke/lazydev.nvim', -- https://github.com/folke/lazydev.nvim
  ft = 'lua',
  ---@type lazydev.Config
  opts = {
    library = {
      -- 'lazy.nvim',
      -- 'snacks.nvim',
      -- 'lazydev.nvim',
      -- 'tailwind-tools.nvim',
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
