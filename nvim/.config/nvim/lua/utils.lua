local M = {}

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

return M
