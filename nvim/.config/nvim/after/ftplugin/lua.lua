require('nvim-surround').buffer_setup({
  surrounds = {
    F = {
      add = function()
        return {
          { ('function %s() '):format(require('nvim-surround.config').get_input('Enter the function name: ')) },
          { ' end' },
        }
      end,
    },
  },
})

vim.keymap.set('i', '<', function()
  if vim.bo.ft ~= 'lua' then
    return '<'
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } }):type()

  if str == 'string_content' or str == 'string' then
    return '<><Left>'
  end

  return '<'
end, { desc = 'Auto-pair `>` when typing `<`', expr = true })
