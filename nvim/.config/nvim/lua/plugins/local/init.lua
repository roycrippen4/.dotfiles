require('plugins.local.tabufline.lazyload')

local logger_ok, _ = pcall(require, 'plugins.local.logger')
if not logger_ok then
  print('logger not ok')
  return
end

local term_ok, _ = pcall(require, 'plugins.local.term')
if not term_ok then
  print('term not ok')
  log('term not ok')
end

local macro_flash_ok, _ = pcall(require, 'plugins.local.macro_flash')
if not macro_flash_ok then
  log('macro_flash not ok')
  return
end

local quitter_ok, _ = pcall(require, 'plugins.local.quitter')
if not quitter_ok then
  log('quitter not ok')
  return
end

local renamer_ok, _ = pcall(require, 'plugins.local.renamer')
if not renamer_ok then
  log('renamer not ok')
  return
end

local search_ok, _ = pcall(require, 'plugins.local.hlsearch')
if not search_ok then
  log('search not ok')
  return
end

local scroll_ok, _ = pcall(require, 'plugins.local.scrolleof')
if not scroll_ok then
  log('scroll not ok')
  return
end

local runner_ok, _ = pcall(require, 'plugins.local.webdev_script_runner')
if not runner_ok then
  log('node not ok')
  return
end
