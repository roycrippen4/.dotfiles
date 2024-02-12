local ibl = require('ibl')
dofile(vim.g.base46_cache .. 'blankline')

-- local hooks = require('ibl.hooks')
-- local highlight = {
--   'RainbowDelimiterRed',
--   'RainbowDelimiterYellow',
--   'RainbowDelimiterBlue',
--   'RainbowDelimiterOrange',
--   'RainbowDelimiterGreen',
--   'RainbowDelimiterViolet',
--   'RainbowDelimiterCyan',
-- }

ibl.setup({
  indent = { char = '▏', highlight = 'IblChar' },
  -- scope = {
  -- char = '▏',
  -- highlight = highlight,
  -- include = {
  --   node_type = {
  --     lua = { 'return_statement', 'table_constructor' },
  --     jsx = { 'jsx_self_closing_element' },
  --     tsx = { 'jsx_self_closing_element' },
  --   },
  -- },
  -- },
})

-- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
