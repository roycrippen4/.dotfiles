local M = {}
local tab_modules = require('plugins.configs.tabufline')

local highlights = require('custom.highlights')

M.ui = {
  hl_add = highlights.add,
  hl_override = highlights.override,

  tabufline = {
    overriden_modules = function(modules)
      modules[1] = vim.g.NvimTreeOverlayTitle
      modules[2] = tab_modules.bufferlist()
      modules[4] = ''
    end,
    enabled = true,
    lazyload = false,
  },
}

M.base46 = {
  integrations = {
    'blankline',
    'cmp',
    'defaults',
    'devicons',
    'git',
    'lsp',
    'mason',
    'nvchad_updater',
    'nvcheatsheet',
    'nvdash',
    'nvimtree',
    'statusline',
    'syntax',
    'treesitter',
    'tbline',
    'telescope',
    'whichkey',
  },
}

return M
