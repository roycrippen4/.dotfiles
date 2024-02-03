local function is_new_search(char)
  return vim.fn.mode() == 'c' and vim.fn.keytrans(char) == '<CR>' and vim.fn.getcmdtype() == '/'
end

local id = nil
local ns = vim.api.nvim_create_namespace('search_virt')

local function clear()
  if id ~= nil then
    vim.api.nvim_buf_del_extmark(0, ns, id)
  end
end

---@param cur integer search item the mouse is on
---@param total integer total count of search items
local function draw_virt(cur, total)
  clear()
  if cur == 0 and total == 0 then
    return
  end
  return vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
    virt_text = { { '[' .. cur .. '/' .. total .. ']', 'NoiceVirtualTextOn' } },
    virt_text_pos = 'eol',
  })
end

vim.on_key(function(char)
  if vim.fn.mode() == 'i' and vim.bo.ft == 'lua' then
    if require('core.utils').should_format_lua_func() and '<CR>' == vim.fn.keytrans(char) then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>O', true, true, true), 'n', true)
    end
  end

  if is_new_search(char) then
    vim.schedule(function()
      local searchcount = vim.fn.searchcount()
      id = draw_virt(searchcount.current, searchcount.total)
    end)
  end

  if vim.fn.mode() == 'n' then
    vim.schedule(function()
      local new_hlsearch = vim.tbl_contains({ 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
      local searchcount = vim.fn.searchcount()

      if new_hlsearch and searchcount.current ~= 0 then
        id = draw_virt(searchcount.current, searchcount.total)
      end

      if vim.opt.hlsearch:get() ~= new_hlsearch then
        vim.opt.hlsearch = new_hlsearch
        if not new_hlsearch then
          clear()
        end
      end
    end)
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))
