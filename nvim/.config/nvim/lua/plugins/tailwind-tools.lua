---@module "tailwind-tools"
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
  ---@type TailwindTools.Option
  opts = {
    server = {
      on_attach = require('lsp').on_attach,
      settings = {
        lint = {
          cssConflict = 'warning',
          invalidApply = 'error',
          invalidConfigPath = 'error',
          invalidScreen = 'error',
          invalidTailwindDirective = 'error',
          invalidVariant = 'error',
        },
        experimental = {
          classRegex = {
            'tw`([^`]*)',
            'tw="([^"]*)',
            'tw={"([^"}]*)',
            'tw\\.\\w+`([^`]*)',
            'tw\\(.*?\\)`([^`]*)',
            { 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { 'classnames\\(([^)]*)\\)', "'([^']*)'" },
            { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
            { 'cn\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          },
        },
      },
    },
  },
}
