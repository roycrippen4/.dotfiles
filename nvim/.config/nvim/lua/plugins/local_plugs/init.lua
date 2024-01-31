local logger_ok, _ = pcall(require, 'plugins.local_plugs.logger')
if not logger_ok then
  print('logger not ok')
  return
end

local utils_ok, _ = pcall(require, 'plugins.local_plugs.utils')
if not utils_ok then
  log('utils not ok')
  return
end

local autosave_ok, _ = pcall(require, 'plugins.local_plugs.autosave')
if not autosave_ok then
  log('autosave not ok')
  return
end

local macro_flash_ok, _ = pcall(require, 'plugins.local_plugs.macro_flash')
if not macro_flash_ok then
  log('macro_flash not ok')
  return
end

local quitter_ok, _ = pcall(require, 'plugins.local_plugs.quitter')
if not quitter_ok then
  log('quitter not ok')
  return
end

local renamer_ok, _ = pcall(require, 'plugins.local_plugs.renamer')
if not renamer_ok then
  log('renamer not ok')
  return
end

local search_ok, _ = pcall(require, 'plugins.local_plugs.hlsearch')
if not search_ok then
  log('search not ok')
  return
end

local scroll_ok, _ = pcall(require, 'plugins.local_plugs.scrolleof')
if not scroll_ok then
  log('scroll not ok')
  return
end

local spinner_ok, _ = pcall(require, 'plugins.local_plugs.spinner')
if not spinner_ok then
  log('spinner not ok')
  return
end

local yoink_ok, _ = pcall(require, 'plugins.local_plugs.yoink')
if not yoink_ok then
  log('yoink not ok')
  return
end

-- local highlighter_ok, hl = pcall(require, 'plugins.local_plugs.highlighter')
-- if not highlighter_ok then
--   log('highlighter not ok')
--   return
-- else
--   hl.setup()
-- end
