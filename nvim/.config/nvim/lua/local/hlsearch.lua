local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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

---@return boolean|nil
local function should_format_lua_func()
  if vim.bo.ft ~= 'lua' then
    return false
  end

  local col = vim.fn.getpos('.')[3]
  local start_pos, end_pos = vim.api.nvim_get_current_line():find('%)%s*end')
  return start_pos and col > start_pos and col <= end_pos
end

local id = nil
local ns = vim.api.nvim_create_namespace('search_virt')

local function clear()
  if id ~= nil then
    vim.api.nvim_buf_del_extmark(0, ns, id)
  end
end

local function draw_virt()
  local count = vim.fn.searchcount()
  clear()
  if not count or (count.current == 0 and count.total == 0) then
    return
  end
  return vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
    virt_text = { { '[' .. count.current .. '/' .. count.total .. ']', 'NoiceVirtualTextOn' } },
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

vim.on_key(function(char)
  local tchar = vim.fn.keytrans(char)
  local mode = vim.fn.mode()
  local is_cr = '<CR>' == tchar

  if mode == 'c' and is_cr and vim.fn.getcmdtype() == '/' then
    id = draw_virt()
    return
  end

  if mode == 'n' then
    vim.schedule(function()
      local new_hlsearch = vim.tbl_contains({ 'n', 'N', '*', '#', '?', '/' }, char)
      vim.opt.hlsearch = new_hlsearch
      clear()

      if new_hlsearch then
        id = draw_virt()
        return
      end
    end)
  end

  if mode == 'i' and is_cr and (should_format_lua_func() or should_format_svelte_block()) then
    feed('<Esc>O', 'n')
    return
  end

  if mode == 'i' and is_cr and (should_format_lua_func() or should_format_svelte_block()) then
    feed('<Esc>O', 'n')
    return
  end
end, ns)

autocmd({ E.BufLeave, E.BufEnter }, {
  group = augroup('HL_Search', { clear = true }),
  pattern = '*',
  callback = function()
    if id ~= nil then
      clear()
    end
  end,
})
