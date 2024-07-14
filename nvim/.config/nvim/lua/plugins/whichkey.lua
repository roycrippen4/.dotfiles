return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    require('which-key').add({
      --stylua: ignore start
      { '<leader>d',  group = '[D]ebug',   icon = '' },
      { '<leader>f',  group = '[F]ind',    icon = '' },
      { '<leader>l',  group = '[L]SP',     icon = '' },
      { '<leader>fg', group = '[G]it',     icon = '' },
      { '<leader>p',  group = '[P]ackage', icon = '' },
      { '<leader>t',  group = '[T]rouble', icon = '' },
      { '<leader>i',  group = '[I]nspect', icon = '󱡴' },
      --stylua: ignore end
    })
  end,
}
