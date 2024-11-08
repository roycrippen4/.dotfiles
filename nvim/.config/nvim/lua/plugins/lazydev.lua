---@type LazyPluginSpec
return {
  'folke/lazydev.nvim', -- https://github.com/folke/lazydev.nvim
  ft = 'lua',
  dependencies = {
    { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  },
  ---@type lazydev.Config
  opts = {
    library = {
      'lazy.nvim',
      'snacks.nvim',
      'lazydev.nvim',
      'tailwind-tools.nvim',
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  },
}
