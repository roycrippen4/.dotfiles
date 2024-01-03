local M = {}
local map = vim.keymap.set

local function quit_win()
  local winnr = vim.api.nvim_get_current_win()
  vim.api.nvim_win_close(winnr, true)
end

M.open = function()
  local currName = vim.fn.expand('<cword>') .. ' '

  local win = require('plenary.popup').create(currName, {
    title = 'Renamer',
    style = 'minimal',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    relative = 'cursor',
    borderhighlight = 'FloatBorder',
    titlehighlight = 'RenamerTitle',
    focusable = true,
    width = 25,
    height = 1,
    line = 'cursor+2',
    col = 'cursor-1',
  })

  vim.cmd('normal A')
  vim.cmd('startinsert')

  map({ 'i', 'n' }, '<Esc>', function()
    quit_win()
  end, { buffer = 0 })

  map('n', 'q', function()
    quit_win()
  end, { buffer = 0 })

  map({ 'i', 'n' }, '<CR>', function()
    require('nvchad.renamer').apply(currName, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end

M.apply = function(curr, win)
  ---@diagnostic disable-next-line
  local newName = vim.trim(vim.fn.getline('.'))
  vim.api.nvim_win_close(win, true)

  if #newName > 0 and newName ~= curr then
    local params = vim.lsp.util.make_position_params()
    params.newName = newName

    vim.lsp.buf_request(0, 'textDocument/rename', params)
  end
end

return M
