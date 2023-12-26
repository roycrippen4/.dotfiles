local M = {}
local tab_modules = require('plugins.configs.tabufline')
local status_modules = require('plugins.configs.statusline')

local highlights = require('custom.highlights')

local function set_modules(modules)
  if vim.api.nvim_get_mode().mode == 'c' then
    modules[1] = status_modules.noice_cmdline()
    modules[2] = ''
    modules[3] = ''
    modules[5] = ''
    modules[7] = status_modules.lsp_diagnostics()
    modules[8] = status_modules.lsp_status()
    modules[9] = status_modules.cursor_position()
    modules[10] = status_modules.cwd()
    return modules
  end
  modules[1] = status_modules.mode_module()
  modules[2] = status_modules.file_info()
  modules[3] = status_modules.git()
  modules[5] = ''
  modules[7] = status_modules.lsp_diagnostics()
  modules[8] = status_modules.lsp_status()
  modules[9] = status_modules.cursor_position()
  modules[10] = status_modules.cwd()
  return modules
end

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
      set_modules(modules)
      -- modules[1] = status_modules.mode_module()
      -- modules[2] = status_modules.file_info()
      -- modules[3] = status_modules.git()
      -- modules[5] = ''
      -- modules[7] = status_modules.lsp_diagnostics()
      -- modules[8] = status_modules.lsp_status()
      -- modules[9] = status_modules.cursor_position()
      -- modules[10] = status_modules.cwd()
    end,
  },
}

return M
