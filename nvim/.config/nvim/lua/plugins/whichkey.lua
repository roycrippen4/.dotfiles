---@type LazyPluginSpec
return {
  'folke/which-key.nvim', -- https://github.com/folke/which-key.nvim
  ---@type wk.Opts
  opts = {
    spec = {
      --stylua: ignore start
      { '<leader>d',  group = '[D]ebug',      icon = '' },
      { '<leader>f',  group = '[F]ind',       icon = '' },
      { '<leader>g',  group = '[G]it',        icon = '' },
      { '<leader>i',  group = '[I]nspect',    icon = '󱡴' },
      { '<leader>l',  group = '[L]SP',        icon = '' },
      { '<leader>n',  group = '[N]eotest',    icon = '󰙨' },
      { '<leader>s',  group = '[S]cissors',   icon = '' },
      { '<leader>t',  group = '[T]rouble',    icon = '' },
      { '<leader>c',  group = '[C]rates',     icon = '', mode = { "v", "n" } },
      -- stylua: ignore end
    },
  },
}
