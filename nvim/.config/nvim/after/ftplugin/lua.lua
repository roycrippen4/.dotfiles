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

local function autopair_angles()
  local pos = vim.api.nvim_win_get_cursor(0)
  local str = vim.treesitter.get_node({ pos = { pos[1] - 1, pos[2] } }):type()

  if str == 'string_content' or str == 'string' then
    return '<><Left>'
  end

  return '<'
end

vim.keymap.set('i', '<', autopair_angles, { desc = 'Auto-pair `>` when typing `<`', expr = true, buffer = true })
vim.keymap.set('n', '<leader>lr', '<cmd> source <cr>', { desc = '[R]un file', buffer = true })
vim.keymap.set(
  'n',
  '<leader>lt',
  '<cmd> TermExec direction=vertical size=80 cmd="./scripts/test" <cr>',
  { desc = '[R]un file', buffer = true }
)
