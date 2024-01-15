local map = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

local winnr = vim.api.nvim_get_current_win()
local buf = vim.api.nvim_win_get_buf(winnr)
local bufname = vim.api.nvim_buf_get_name(buf)

map('n', '<Leader>lr', function()
  vim.cmd.RustLsp('runnables')
end, { silent = true, buffer = bufnr })
