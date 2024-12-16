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

---@return boolean?
local function should_format_lua_func()
  local col = vim.fn.getpos('.')[3]
  local start_pos, end_pos = vim.api.nvim_get_current_line():find('%)%s*end')
  return start_pos and col > start_pos and col <= end_pos
end

vim.keymap.set('i', '<cr>', function()
  if should_format_lua_func() then
    feed('<cr><esc>O', 'n')
  else
    return '<cr>'
  end
end, { expr = true })

vim.keymap.set('i', '<', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } }):type()

  if str == 'string_content' or str == 'string' then
    return '<><Left>'
  end

  return '<'
end, { desc = 'Auto-pair `>` when typing `<`', expr = true })
