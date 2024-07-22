return {
  'folke/which-key.nvim',
  lazy = false,
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
      {
        mode = 'n',
        { '<leader>ff',  '<cmd> Telescope find_files      <CR>', desc = 'Find files',             icon =  "" },
        { '<leader>fa',  '<cmd> Telescope autocommands    <CR>', desc = 'Find autocommands',      icon =  "󱚟" },
        { '<leader>fb',  '<cmd> Telescope buffers         <CR>', desc = 'Find buffers',           icon =  "" },
        { '<leader>fc',  '<cmd> Telescope commands        <CR>', desc = 'Find commands',          icon =  "󰘳" },
        { '<leader>fh',  '<cmd> Telescope help_tags       <CR>', desc = 'Find help',              icon =  "󰋖" },
        { '<leader>fk',  '<cmd> Telescope keymaps         <CR>', desc = 'Find keymaps',           icon =  "" },
        { '<leader>fl',  '<cmd> Telescope highlights      <CR>', desc = 'Find highlight groups',  icon =  "󰸱" },
        { '<leader>fm',  '<cmd> Telescope marks           <CR>', desc = 'Find bookmarks',         icon =  "" },
        { '<leader>fo',  '<cmd> Telescope oldfiles        <CR>', desc = 'Find oldfiles',          icon =  "" },
        { '<leader>fr',  '<cmd> Telescope resume          <CR>', desc = 'Resume previous search', icon =  "" },
        { '<leader>fw',  '<cmd> Telescope live_grep       <CR>', desc = 'Find word (cwd)',        icon =  "" },
        { '<leader>fgc', '<cmd> Telescope git_commits     <CR>', desc = 'Find commits',           icon =  "" },
        { '<leader>fgs', '<cmd> Telescope git_status      <CR>', desc = 'Find Git status',        icon =  "󱖫" },
        { '<leader>fp',  '<cmd> Telescope treesitter_info <CR>', desc = 'Find treesitter info',   icon =  "" },
      },
      --stylua: ignore end
    })
  end,
}
