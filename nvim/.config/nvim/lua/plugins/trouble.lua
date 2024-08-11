---@type LazyPluginSpec
return {
  'folke/trouble.nvim', -- https://github.com/folke/trouble.nvim
  opts = {},
  keys = {
    {
      '<leader>td',
      '<cmd> Trouble diagnostics toggle <cr>',
      desc = '[T]rouble Diagnostics',
    },
  },
}
