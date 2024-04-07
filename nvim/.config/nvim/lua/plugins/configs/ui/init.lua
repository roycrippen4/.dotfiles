local M = {}
require('plugins.configs.ui.tabufline.lazyload')
require('plugins.configs.ui.statusline')
require('plugins.configs.ui.macro_flash')
local hl = require('plugins.configs.ui.highlights')

M.ui = {
  theme = 'doomchad',
  hl_add = hl.add,
  hl_override = hl.override,
  changed_themes = {},
  cmp = {
    icons = true,
    lspkind_text = true,
    style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
  },
  telescope = { style = 'borderless' }, -- borderless / bordered

  base46 = {
    integrations = {
      'blankline',
      'bufferline',
      'cmp',
      'codeactionmenu',
      'dap',
      'defaults',
      'devicons',
      'git',
      'hop',
      'illuminate',
      'lsp',
      'lspsaga',
      'mason',
      'nvimtree',
      'rainbowdelimiters',
      'semantic_tokens',
      -- 'statusline',
      'syntax',
      'telescope',
      'todo',
      'treesitter',
      'trouble',
      'whichkey',
    },
  },
}

M.plugins = ''
M.lazy_nvim = require('plugins.configs.lazy_nvim')
M.mappings = require('core.mappings')

return M
