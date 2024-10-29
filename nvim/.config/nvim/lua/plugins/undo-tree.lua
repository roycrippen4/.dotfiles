-- local ut_open = false
-- local function ut_toggle()
--   if ut_open then
--     require('nvim-tree.api').tree.toggle()
--     vim.cmd.UndotreeToggle()
--     ut_open = true
--   else
--     vim.cmd.UndotreeToggle()
--     require('nvim-tree.api').tree.toggle()
--     vim.cmd('wincmd l')
--     ut_open = false
--   end
-- end

-- ---@type LazyPluginSpec
-- return {
--   'mbbill/undotree', -- https://github.com/mbbill/undotree
--   keys = {
--     { '<leader>ut', ut_toggle, desc = 'UndoTree' },
--   },
-- }

return {
  'jiaoshijie/undotree',
  dependencies = 'nvim-lua/plenary.nvim',
  config = true,
  keys = {
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
