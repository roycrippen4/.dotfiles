local M = {}

M.options = {
  nvchad_branch = 'v3.0',
}

M.ui = {
  ------------------------------- base46 -------------------------------------
  hl_add = {},
  hl_override = {},
  changed_themes = {},
  -- theme_toggle = { 'onedark', 'one_light' },
  theme = 'onedark', -- default theme
  transparency = false,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = 'borderless' }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = 'default', -- default/vscode/vscode_colored/minimal
    separator_style = 'default',
    overriden_modules = nil,
  },

  tabufline = { enabled = false },
  nvdash = { enabled = false },
  cheatsheet = { enabled = false },
  term = { enabled = false },

  lsp = {
    signature = false,
    semantic_tokens = true,
  },
}

M.base46 = {
  integrations = {
    'alpha',
    'blankline',
    'bufferline',
    'cmp',
    'codeactionmenu',
    'dap',
    'defaults',
    'devicons',
    'git',
    'hop',
    'lsp',
    'lspsaga',
    'mason',
    'nvimtree',
    'rainbowdelimiters',
    'semantic_tokens',
    'statusline',
    'syntax',
    'tbline',
    'telescope',
    'todo',
    'treesitter',
    'trouble',
    'whichkey',
  },
}

M.plugins = ''
M.lazy_nvim = require('plugins.configs.lazy_nvim')
M.mappings = require('core.mappings')

return M
