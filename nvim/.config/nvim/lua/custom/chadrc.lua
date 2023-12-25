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
    theme = 'default',
    separator_style = 'default',
    overriden_modules = function(modules)
      modules[1] = status_modules.mode_module()
      modules[2] = (function()
        if vim.api.nvim_get_mode().mode == 'c' then
          return ''
        end
        return status_modules.file_info()
      end)()
      modules[3] = (function()
        if vim.api.nvim_get_mode().mode == 'c' then
          return ''
        end
        return status_modules.git()
      end)()
      modules[5] = ''
      -- modules[6] = status_modules
      modules[7] = status_modules.lsp_diagnostics()
      modules[8] = status_modules.lsp_status()
      modules[9] = status_modules.cursor_position()
      modules[10] = status_modules.cwd()
    end,
  },
}

return M
