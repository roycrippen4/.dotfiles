local M = {}
local tab_modules = require('plugins.configs.tabufline')
local status_modules = require('plugins.configs.statusline')
local highlights = require('custom.highlights')
local theme = require('custom.themes.roydark')

local timer = vim.loop.new_timer()

local function redraw()
  vim.cmd('redrawstatus')
end

if timer then
  timer:start(1000, 1000, vim.schedule_wrap(redraw))
end

local function set_modules(modules)
  modules[1] = status_modules.fileformat()
  modules[2] = status_modules.mode()
  modules[3] = status_modules.file_info()
  modules[4] = status_modules.git()
  modules[6] = '%='
  modules[7] = status_modules.lsp_diagnostics()
  modules[8] = status_modules.lsp_status()
  modules[9] = status_modules.cursor_position()
  modules[10] = status_modules.time()
  modules[11] = status_modules.cwd()
  return modules
  -- end
end

M.ui = {
  theme = 'roydark',
  hl_add = highlights.add,
  hl_override = highlights.override,

  tabufline = {
    overriden_modules = function(modules)
      modules[1] = vim.g.NvimTreeOverlayTitle
      modules[2] = tab_modules.bufferlist()
      modules[4] = tab_modules.host()
    end,
    enabled = true,
    lazyload = false,
  },

  statusline = {
    overriden_modules = function(modules)
      set_modules(modules)
    end,
  },
}

return M
