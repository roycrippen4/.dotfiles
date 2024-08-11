---@type LazyPluginSpec
return {
  'folke/which-key.nvim',
  lazy = false,
  opts = {},
  config = function()
    require('which-key').add({
      --stylua: ignore start
      { '<leader>c',  group = '[C]rates',   icon = '' },
      { '<leader>d',  group = '[D]ebug',   icon = '' },
      { '<leader>f',  group = '[F]ind',    icon = '' },
      { '<leader>l',  group = '[L]SP',     icon = '' },
      { '<leader>fg', group = '[G]it',     icon = '' },
      { '<leader>p',  group = '[P]ackage', icon = '' },
      { '<leader>t',  group = '[T]rouble', icon = '' },
      { '<leader>i',  group = '[I]nspect', icon = '󱡴' },
      { '<leader>g',  group = '[G]it',     icon = '' },
      --stylua: ignore end
    })
  end,
}
