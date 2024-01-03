local renamer_ok, _ = pcall(require, 'plugins.local_plugs.renamer')
if not renamer_ok then
  return
end

local search_ok, _ = pcall(require, 'plugins.local_plugs.hlsearch')
if not search_ok then
  return
end

local logger_ok, _ = pcall(require, 'plugins.local_plugs.logger')
if not logger_ok then
  return
end

local spinner_ok, _ = pcall(require, 'plugins.local_plugs.spinner')
if not spinner_ok then
  return
end

local scroll_ok, _ = pcall(require, 'plugins.local_plugs.scrolleof')
if not scroll_ok then
  return
end

local autosave_ok, _ = pcall(require, 'plugins.local_plugs.autosave')
if not autosave_ok then
  return
end

-- local pretty_hover_ok, _ = pcall(require, 'plugins.local_plugs.pretty_hover')
-- if not pretty_hover_ok then
--   return
-- end
