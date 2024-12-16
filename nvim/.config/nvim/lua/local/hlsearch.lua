local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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
    virt_text = { { '[' .. count.current .. '/' .. count.total .. ']', 'SearchVirtualText' } },
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
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
end, ns)

autocmd({ 'BufLeave', 'BufEnter' }, {
  group = augroup('HL_Search', { clear = true }),
  pattern = '*',
  callback = function()
    if id ~= nil then
      clear()
    end
  end,
})
