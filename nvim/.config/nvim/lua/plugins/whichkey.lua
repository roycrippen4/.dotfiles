---@type LazyPluginSpec
return {
  'folke/which-key.nvim', -- https://github.com/folke/which-key.nvim
  opts = {},
  config = function()
    require('which-key').add({
      --stylua: ignore start
      { '<leader>c',  group = '[C]rates',     icon = '' },
      { '<leader>d',  group = '[D]ebug',      icon = '' },
      { '<leader>f',  group = '[F]ind',       icon = '' },
      { '<leader>fg', group = '[F]ind [G]it', icon = '' },
      { '<leader>g',  group = '[G]it',        icon = '' },
      { '<leader>i',  group = '[I]nspect',    icon = '󱡴' },
      { '<leader>l',  group = '[L]SP',        icon = '' },
      { '<leader>p',  group = '[P]ackage',    icon = '' },
      { '<leader>s',  group = '[S]cissors',   icon = '' },
      { '<leader>t',  group = '[T]rouble',    icon = '' },
      --stylua: ignore end
    })
  end,
}
