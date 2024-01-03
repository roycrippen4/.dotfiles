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
  if is_new_search(char) then
    vim.defer_fn(function()
      local searchcount = vim.fn.searchcount()
      id = draw_virt(searchcount.current, searchcount.total)
    end, 0)
  end

  if vim.fn.mode() == 'n' then
    vim.defer_fn(function()
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
    end, 0)
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))
