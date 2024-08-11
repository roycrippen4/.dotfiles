---@type LazyPluginSpec
return {
  'lukas-reineke/indent-blankline.nvim', -- https://github.com/lukas-reineke/indent-blankline.nvim
  main = 'ibl',
  event = 'VeryLazy',

  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = { char = '▏' },
    scope = {
      char = '▏',
      include = {
        node_type = {
          lua = { 'return_statement', 'table_constructor' },
          jsx = { 'jsx_self_closing_element' },
          tsx = { 'jsx_self_closing_element' },
        },
      },
    },
  },
}
