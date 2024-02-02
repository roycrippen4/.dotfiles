local function generate_range(start, ending, step)
  local result = {}
  for i = start, ending, step do
    table.insert(result, i)
  end
  log(result)
  return result
end

---@param x integer
---@param y integer?
---@param step integer?
---@param lua_indexing boolean?
---@return integer[]|nil
function _G.range(x, y, step, lua_indexing)
  if step == nil or step == 0 then
    step = 1
  end

  if lua_indexing == nil then
    lua_indexing = false
  end

  if y ~= nil and x > y and step > 0 then
    step = -step
  end

  if y == nil then
    local start = lua_indexing and 1 or 0
    local ending = x + (lua_indexing and 0 or 1)
    return generate_range(start, ending, step)
  else
    if (step > 0 and x <= y) or (step < 0 and x >= y) then
      return generate_range(x, y, step)
    else
      return nil
    end
  end
end
