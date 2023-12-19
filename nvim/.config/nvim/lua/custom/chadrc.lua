local M = {}

local highlights = require('custom.highlights')

M.ui = {
  hl_add = highlights.add,
  hl_override = highlights.override,
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
    'tbline',
    'telescope',
    'whichkey',
    'dap',
    'hop',
    'rainbowdelimiters',
    'todo',
    'trouble',
    'notify',
  },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

return M
