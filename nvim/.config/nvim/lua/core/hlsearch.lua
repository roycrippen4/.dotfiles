local api = vim.api
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.hl_search = function()
  vim.o.hlsearch = true
  M.ns = api.nvim_create_namespace('search')
  vim.api.nvim_buf_clear_namespace(0, M.ns, 0, -1)

  local search_pat = '\\c\\%#' .. vim.fn.getreg('/')
  local ring = vim.fn.matchadd('IncSearch', search_pat)
  vim.cmd('redraw')

  local sc = vim.fn.searchcount()
  M.id = vim.api.nvim_buf_set_extmark(0, M.ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
    virt_text = { { '[' .. sc.current .. '/' .. sc.total .. ']', 'NoiceVirtualTextOn' } },
    virt_text_pos = 'eol',
  })

  vim.fn.matchdelete(ring)
  vim.cmd('redraw')
end

vim.keymap.set(
  'n',
  'n',
  "nzz<cmd>lua require('core.hlsearch').hl_search()<CR>",
  { desc = 'go to next search and highlight' }
)

vim.keymap.set(
  'n',
  'N',
  "Nzz<cmd>lua require('core.hlsearch').hl_search()<CR>",
  { desc = 'go to prev search and highlight' }
)

function M.clear()
  if M.ns and M.id then
    vim.api.nvim_buf_del_extmark(0, M.ns, M.id)
  end
  vim.o.hlsearch = false
end

-- disables hlsearch highlight and extmarks
autocmd('CursorMoved', {
  callback = function()
    M.clear()
  end,
})

return M
