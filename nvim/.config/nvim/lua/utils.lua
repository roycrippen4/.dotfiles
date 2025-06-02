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
    border = 'none',
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
      vim.api.nvim_set_hl(0, 'MsgArea', { bg = colors.black3 })
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

function M.tbl_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

---Returns the list of currently selected lines
---@return string?
function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  local valid_modes = { 'v', 'V', '' }
  if not vim.tbl_contains(valid_modes, mode) then
    vim.notify('exiting', vim.log.levels.INFO)
    return
  end

  -- if we are in visual mode use the live position
  _, csrow, cscol, _ = unpack(vim.fn.getpos('.'))
  _, cerow, cecol, _ = unpack(vim.fn.getpos('v'))
  if mode == 'V' then
    -- visual line doesn't provide columns
    cscol, cecol = 0, 999
  end
  -- exit visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)

  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  if type(lines) == 'string' then
    lines = { lines }
  end

  local n = M.tbl_length(lines)

  if n <= 0 then
    return ''
  end

  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, '\n')
end

--- TODO: Try to add the hl_yank stuff
function M.visual_yank()
  local selection = M.get_visual_selection()
  if not selection then
    return
  end

  vim.fn.setreg('+', selection)
  vim.hl.on_yank()
end

vim.keymap.set('v', '<M-I>', M.visual_yank)

return M
