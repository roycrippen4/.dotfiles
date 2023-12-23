local M = {}
local tab_modules = require('plugins.configs.tabufline')
local status_modules = require('plugins.configs.statusline')

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

  statusline = {
    theme = 'default', -- default/vscode/vscode_colored/minimal
    separator_style = 'default',
    overriden_modules = function(modules)
      modules[1] = status_modules.mode_module()
      modules[2] = status_modules.fileInfo()
      modules[3] = status_modules.git()
      modules[5] = ''
      modules[7] = status_modules.LSP_Diagnostics()
      modules[8] = status_modules.LSP_status()
      modules[9] = status_modules.cursor_position()
      modules[10] = status_modules.cwd()

      -- modules[10] = ''
      -- modules[11] = ''
    end,
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
