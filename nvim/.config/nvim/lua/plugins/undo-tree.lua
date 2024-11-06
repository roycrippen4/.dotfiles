local ut_open = false
local function ut_toggle()
  if ut_open then
    require('nvim-tree.api').tree.toggle()
    vim.cmd.UndotreeToggle()
    ut_open = true
  else
    vim.cmd.UndotreeToggle()
    require('nvim-tree.api').tree.toggle()
    vim.cmd('wincmd l')
    ut_open = false
  end
end

---@type LazyPluginSpec[]
return {
  -- {
  --   'roycrippen4/undo-tree',
  --   dependencies = 'nvim-lua/plenary.nvim',
  --   dev = true,
  --   opts = {},
  --   -- config = true,
  --   keys = {
  --     { '<leader>uu', "<cmd>lua require('undo-tree').toggle()<cr>" },
  --   },
  -- },
  {
    'mbbill/undotree', -- https://github.com/mbbill/undotree
    cmd = 'UndoTreeToggle',
    lazy = false,
    keys = {
      { '<leader>u', ut_toggle, desc = 'UndoTree' },
    },
  },
}

-- return {
--   'jiaoshijie/undotree',
--   dependencies = 'nvim-lua/plenary.nvim',
--   dev = true,
--   config = true,
--   keys = {
--     { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
--   },
-- }
