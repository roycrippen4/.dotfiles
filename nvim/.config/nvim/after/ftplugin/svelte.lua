vim.cmd.runtime({ 'after/ftplugin/javascript.lua', bang = true })

---@param node TSNode?
---@return TSNode?
local function get_previous_node(node)
  if not node then
    return nil
  end

  local previous_node = node:prev_sibling()

  if not previous_node then
    local parent = node:parent()
    if not parent then
      return nil
    end

    previous_node = parent:prev_sibling()
    if not previous_node then
      return nil
    end
  end

  return previous_node
end

---@param node TSNode?
---@return boolean?
local function check_svelte_snippet(node)
  local previous_node = get_previous_node(node)
  return node and previous_node and node:type() == 'snippet_end' and previous_node:type() == 'snippet_start'
end

---@param node TSNode?
---@return boolean?
local function check_svelte_each(node)
  local previous_node = get_previous_node(node)
  return node and previous_node and node:type() == 'each_end' and previous_node:type() == 'each_start'
end

---@param node TSNode?
local function check_svelte_await(node)
  local previous_node = get_previous_node(node)
  return (node and previous_node)
    and vim.iter({ 'await_end', 'catch_start', 'then_start' }):any(function(value)
      return value == node:type()
    end)
    and vim.iter({ 'catch_block', 'then_block', 'await_start' }):any(function(value)
      return value == previous_node:type()
    end)
end

---@param node TSNode?
---@return boolean?
local function check_svelte_if(node)
  local previous_node = get_previous_node(node)
  return (node and previous_node)
    and vim.iter({ 'else_start', 'else_if_start', 'if_end' }):any(function(value)
      return value == node:type()
    end)
    and vim.iter({ 'if_start', 'else_block', 'else_if_block' }):any(function(value)
      return value == previous_node:type()
    end)
end

local function should_format_svelte_block()
  if vim.bo.ft ~= 'svelte' then
    return false
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local current_node = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } })
  return check_svelte_if(current_node)
    or check_svelte_each(current_node)
    or check_svelte_snippet(current_node)
    or check_svelte_await(current_node)
end

vim.keymap.set('i', '<cr>', function()
  if should_format_svelte_block() then
    feed('<cr><esc>O', 'n')
  else
    return '<cr>'
  end
end, { expr = true })
