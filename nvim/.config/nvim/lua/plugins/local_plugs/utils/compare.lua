local M = {}

---@param t1 table the first table for comparison
---@param t2 table the first table for comparison
---@param ignore_mt boolean? Defaults to `true`. Ignores the metatables
function M.deep_equals(t1, t2, ignore_mt)
  if t1 == t2 then
    return true
  end

  local t1Type = type(t1)
  local t2Type = type(t2)

  if t1Type ~= t2Type then
    return false
  end

  if t1Type ~= 'table' then
    return false
  end

  if not ignore_mt then
    local mt1 = getmetatable(t1)
    if mt1 and mt1.__eq then
      return t1 == t2
    end
  end

  for key1, value1 in pairs(t1) do
    local value2 = t2[key1]
    if value2 == nil or M.deep_equals(value1, value2, ignore_mt) == false then
      return false
    end
  end

  for key2, _ in pairs(t2) do
    if t1[key2] == nil then
      return false
    end
  end
  return true
end

return M
