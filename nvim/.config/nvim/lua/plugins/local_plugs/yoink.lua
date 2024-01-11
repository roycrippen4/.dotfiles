local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
---@type integer[]|nil
local cursor_pos

augroup('yankpost', { clear = true })
autocmd({ 'VimEnter', 'CursorMoved' }, {
  group = 'yankpost',
  pattern = '*',
  callback = function()
    cursor_pos = vim.fn.getpos('.')
  end,
})
autocmd('TextYankPost', {
  group = 'yankpost',
  pattern = '*',
  callback = function()
    if vim.v.event.operator == 'y' then
      vim.fn.setpos('.', cursor_pos)
    end
  end,
})

-- highlights the yanked portion of the buffer on yank
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = '*',
})
