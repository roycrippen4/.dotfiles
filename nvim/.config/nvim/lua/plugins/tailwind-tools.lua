---@type LazyPluginSpec
return {
  'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- https://github.com/nvim-treesitter/nvim-treesitter
    'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  },
  cond = function()
    return require('core.utils').has_file('tailwind.config.js') or require('core.utils').has_file('tailwind.config.ts')
  end,
  opts = {},
}
