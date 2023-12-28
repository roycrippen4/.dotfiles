local M = {}

M.options = {
  nvchad_branch = 'v3.0',
}

M.ui = {
  ------------------------------- base46 -------------------------------------
  hl_add = {},
  hl_override = {},
  changed_themes = {},
  theme_toggle = { 'onedark', 'one_light' },
  theme = 'onedark', -- default theme
  transparency = false,
  lsp_semantic_tokens = false, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

  cmp = {
    icons = true,
    -- lspkind_text = true,
    style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
    border_color = 'blue', -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = 'colored', -- colored / simple
  },

  telescope = { style = 'borderless' }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = 'default', -- default/vscode/vscode_colored/minimal
    separator_style = 'default',
    overriden_modules = nil,
  },

  tabufline = {
    overriden_modules = nil,
    enabled = true,
    lazyload = true,
  },

  -- nvdash (dashboard)
  nvdash = {
    load_on_startup = false,

    header = {
      '           ▄ ▄                   ',
      '       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ',
      '       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ',
      '    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ',
      '  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ',
      '  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄',
      '▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █',
      '█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █',
      '    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ',
    },

    buttons = {
      { '  Find File', 'Spc f f', 'Telescope find_files' },
      { '󰈚  Recent Files', 'Spc f o', 'Telescope oldfiles' },
      { '󰈭  Find Word', 'Spc f w', 'Telescope live_grep' },
      { '  Bookmarks', 'Spc m a', 'Telescope marks' },
      { '  Themes', 'Spc t h', 'Telescope themes' },
      { '  Mappings', 'Spc c h', 'NvCheatsheet' },
    },
  },

  cheatsheet = { theme = 'grid' }, -- simple/grid

  lsp = {
    signature = true,
    semantic_tokens = false,
  },
  term = {
    enabled = false,
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
    -- 'whichkey',
  },
}

M.plugins = '' -- path i.e "custom.plugins", so make custom/plugins.lua file

M.lazy_nvim = require('plugins.configs.lazy_nvim') -- config for lazy.nvim startup options

M.mappings = require('core.mappings')

return M
