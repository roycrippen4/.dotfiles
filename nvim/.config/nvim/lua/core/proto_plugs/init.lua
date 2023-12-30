local searchok, _ = pcall(require, 'core.proto_plugs.hlsearch')

if not searchok then
  return
end

local loggerok, _ = pcall(require, 'core.proto_plugs.logger')
if not loggerok then
  return
end

local spinnerok, _ = pcall(require, 'core.proto_plugs.spinner')
if spinnerok then
  return
end
