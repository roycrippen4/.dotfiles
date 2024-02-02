package.path = package.path .. ';' .. vim.fn.expand('$HOME') .. '/.luarocks/share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. vim.fn.expand('$HOME') .. '/.luarocks/share/lua/5.1/?.lua;'

local M = {}
local tab_modules = require('plugins.local_plugs.tabufline')
local status_modules = require('plugins.local_plugs.statusline')
local highlights = require('custom.highlights')

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
  theme = 'onedark',
  hl_add = highlights.add,
  hl_override = highlights.override,

  tabufline = {
    overriden_modules = function(modules)
      modules[1] = vim.g.NvimTreeOverlayTitle
      modules[2] = tab_modules.bufferlist()
      -- modules[4] = tab_modules.host()
      modules[4] = ''
    end,
    enabled = true,
    lazyload = false,
  },

  statusline = {
    overriden_modules = function(modules)
      set_modules(modules)
    end,
  },

  custom_colors = {
    cursorline = '#252931',
    sep_color = '#454951',
    black = 'black',
    darkest_black = { 'black', -0.9 },
    d_yellow = { 'yellow', -20 },
    d_red = { 'red', -10 },
    green = { 'green', -10 },
    l_blue = '#00C5FF',
    orange = { 'orange', -10 },
    pink = { 'pink', -10 },
  },

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
    'illuminate',
    'lsp',
    'lspsaga',
    'mason',
    'nvchad_updater',
    'nvcheatsheet',
    'nvdash',
    'nvimtree',
    -- 'rainbowdelimiters',
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

return M
