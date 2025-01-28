local M = {}

---Generates an array of numbers from start to stop with step n
---Table is end-inclusive
---@param start integer Starting point
---@param stop integer Stopping point
---@param step integer? Step size
---@return integer[]
function M.range(start, stop, step)
  if start == stop then
    return { start }
  end

  if start < stop and not step then
    step = 1
  end

  if start > stop and not step then
    step = -1
  end

  if start < stop and step < 0 then
    Snacks.notify.error({
      '```lua',
      'utils.range(' .. start .. ', ' .. stop .. ', ' .. step .. ')',
      '            ───┬  ┬',
      '               │  ╰─ Should be positive',
      '               ╰─ Or swap these',
      '```',
    }, { title = 'Invalid Parameters' })
  end

  if start > stop and step > 0 then
    Snacks.notify.error({
      '```lua',
      'utils.range(' .. start .. ', ' .. stop .. ', ' .. step .. ')',
      '            ───┬  ┬',
      '               │  ╰─ Should be negative',
      '               ╰─ Or swap these',
      '```',
    }, { title = 'Invalid Parameters' })
  end

  ---@type integer[]
  local res = {}
  for i = start, stop, step do
    table.insert(res, i)
  end
  return res
end

---Creates an iterator from an array from start to stop with step n
---Table is end-inclusive
---@param start integer Starting point
---@param stop integer Stopping point
---@param step integer? Step size
---@return Iter
function M.range_iter(start, stop, step)
  return vim.iter(M.range(start, stop, step))
end

---@param key string
---@param mode string
function _G.feed(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@type fun(ctx: {buf: integer, event?: string, file?: string, id?: integer, match?: string}): nil
function M.create_backdrop(ctx)
  local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
    relative = 'editor',
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.columns,
    focusable = false,
    style = 'minimal',
    zindex = 10,
  })

  vim.api.nvim_set_hl(0, 'Backdrop', { bg = '#000000', default = true })
  vim.wo[winnr].winhighlight = 'Normal:Backdrop'
  vim.wo[winnr].winblend = 50
  vim.bo[backdrop_bufnr].buftype = 'nofile'

  vim.api.nvim_set_hl(0, 'MsgArea', { bg = '#101215' })
  vim.api.nvim_create_autocmd({ 'WinClosed', 'BufLeave' }, {
    once = true,
    buffer = ctx.buf,
    callback = function()
      vim.api.nvim_set_hl(0, 'MsgArea', { bg = require('plugins.colorscheme.palette').black3 })
      if vim.api.nvim_win_is_valid(winnr) then
        vim.api.nvim_win_close(winnr, true)
      end
      if vim.api.nvim_buf_is_valid(backdrop_bufnr) then
        vim.api.nvim_buf_delete(backdrop_bufnr, { force = true })
      end
    end,
  })
end

--- Recursively gets a given node's anscestor of a given type
---@param types string[] will return the first node that matches one of these types
---@param node TSNode? current node
---@return TSNode?
function M.find_node_ancestor(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  return M.find_node_ancestor(types, node:parent())
end

return M
