---@return boolean
local function should_format_lua_func()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.getpos('.')[3]
  local pattern = '%)%s*end,?%s*$'
  local start_pos, end_pos = line:find(pattern)

  if start_pos then
    local res = col > start_pos and col <= end_pos
    return res
  end

  return false
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
  if count.current == 0 and count.total == 0 then
    return
  end
  return vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
    virt_text = { { '[' .. count.current .. '/' .. count.total .. ']', 'NoiceVirtualTextOn' } },
    virt_text_pos = 'eol',
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

  if mode == 'i' and vim.bo.ft == 'lua' and should_format_lua_func() and is_cr then
    vim.api.nvim_feedkeys('O', 'n', true)
    return
  end
end, ns)
