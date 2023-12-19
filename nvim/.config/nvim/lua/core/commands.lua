local create_cmd = vim.api.nvim_create_user_command
local utils = require('core.utils')

local function clear_cmdarea()
  vim.defer_fn(function()
    vim.api.nvim_echo({}, false, {})
  end, 800)
end

local function autosave()
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
    callback = function()
      if #vim.api.nvim_buf_get_name(0) ~= 0 and vim.bo.buflisted and vim.g.autosave then
        vim.cmd('silent w')

        vim.api.nvim_echo(
          { { '󰄳', 'LazyProgressDone' }, { ' file autosaved at ' .. os.date('%I:%M:%S %p') } },
          false,
          {}
        )

        clear_cmdarea()
      end
    end,
  })
end

create_cmd('AsToggle', function()
  vim.g.autosave = not vim.g.autosave
  if vim.g.autosave then
    autosave()
  end
  if vim.g.autosave then
    vim.api.nvim_echo({ { '󰆓 ', 'LazyProgressDone' }, { 'autosave enabled!' } }, false, {})
  else
    vim.api.nvim_echo({ { '󰚌 ', 'LazyNoCond' }, { 'autosave disabled' } }, false, {})
  end

  clear_cmdarea()
end, {})
vim.keymap.set('n', '<leader>a', function()
  autosave()
end, { desc = 'Toggle Autosave' })
