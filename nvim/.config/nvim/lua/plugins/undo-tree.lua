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
  --   enabled = true,
  --   opts = {},
  --   keys = {
  --     { '<leader>u', "<cmd>lua require('undo-tree').toggle()<cr>" },
  --   },
  -- },
  {
    'mbbill/undotree', -- https://github.com/mbbill/undotree
    cmd = 'UndoTreeToggle',
    lazy = false,
    enabled = true,
    keys = {
      { '<leader>u', ut_toggle, desc = 'UndoTree' },
    },
  },
}
