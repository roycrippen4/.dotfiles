---@module "tailwind-tools"
---@type LazyPluginSpec
return {
  'luckasRanarison/tailwind-tools.nvim', -- https://github.com/luckasRanarison/tailwind-tools.nvim
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ---@type TailwindTools.Option
  opts = {
    document_color = { enabled = false },
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
