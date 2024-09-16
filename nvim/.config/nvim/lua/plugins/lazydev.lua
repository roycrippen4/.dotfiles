return { ---@type LazyPluginSpec
  'folke/lazydev.nvim', -- https://github.com/folke/lazydev.nvim
  ft = 'lua',
  dependencies = {
    { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
  },
  opts = { ---@type lazydev.Config
    library = {
      'lazy.nvim',
      'lazydev.nvim',
      'tailwind-tools.nvim',
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  },
}
