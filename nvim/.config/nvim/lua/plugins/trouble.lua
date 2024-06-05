return {
  'folke/trouble.nvim', -- https://github.com/folke/trouble.nvim
  opts = {
    win = { ---@type trouble.Window.opts
      type = 'split',
      position = 'right',
      size = 100,
    },
  },
  keys = {
    {
      '<leader>td',
      '<cmd> Trouble diagnostics toggle <cr>',
      desc = 'Toggle Trouble Diagnostics',
    },
  },
}
