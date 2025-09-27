---@module "trouble"
---@type LazyPluginSpec
return {
  'folke/trouble.nvim', -- https://github.com/folke/trouble.nvim
  ---@type trouble.Config
  opts = { focus = true },
  keys = {
    {
      '<C-S-D>',
      '<cmd> Trouble diagnostics toggle <cr>',
      desc = '[T]rouble Diagnostics',
    },
  },
}
