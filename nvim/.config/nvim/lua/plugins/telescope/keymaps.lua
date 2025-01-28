local M = {}

M.keys = {
  '<leader>ff',
  '<leader>fa',
  '<leader>fb',
  '<leader>fc',
  '<leader>fh',
  '<leader>fk',
  '<leader>fl',
  '<leader>fm',
  '<leader>fo',
  '<leader>fr',
  '<leader>fw',
  '<leader>fgc',
  '<leader>fgs',
  '<leader>fp',
  '<leader>ft',
}

function M.setup()
  require('which-key').add({
    -- stylua: ignore
    {
      mode = 'n',
      { '<leader>ff', '<cmd> Telescope find_files      <CR>', desc = '[F]ind files',             icon = '' },
      { '<leader>fa', '<cmd> Telescope autocommands    <CR>', desc = '[F]ind autocommands',      icon = '󱚟' },
      { '<leader>fb', '<cmd> Telescope buffers         <CR>', desc = '[F]ind buffers',           icon = '' },
      { '<leader>fc', '<cmd> Telescope commands        <CR>', desc = '[F]ind commands',          icon = '󰘳' },
      { '<leader>fh', '<cmd> Telescope help_tags       <CR>', desc = '[F]ind help',              icon = '󰋖' },
      { '<leader>fk', '<cmd> Telescope keymaps         <CR>', desc = '[F]ind keymaps',           icon = '' },
      { '<leader>fl', '<cmd> Telescope highlights      <CR>', desc = '[F]ind highlight groups',  icon = '󰸱' },
      { '<leader>fm', '<cmd> Telescope marks           <CR>', desc = '[F]ind bookmarks',         icon = '' },
      { '<leader>fo', '<cmd> Telescope oldfiles        <CR>', desc = '[F]ind oldfiles',          icon = '' },
      { '<leader>fr', '<cmd> Telescope resume          <CR>', desc = '[R]esume previous search', icon = '' },
      { '<leader>fw', require("plugins.telescope.multigrep"), desc = '[F]ind word (cwd)',        icon = '' },
      { '<leader>fgc', '<cmd> Telescope git_commits    <CR>', desc = '[F]ind [G]it commits',     icon = '' },
      { '<leader>fgs', '<cmd> Telescope git_status     <CR>', desc = '[F]ind [G]it status',      icon = '󱖫' },
      { '<leader>fp', '<cmd> Telescope treesitter_info <CR>', desc = '[F]ind treesitter info',   icon = '' },
      { '<leader>ft', '<cmd> TodoTelescope             <CR>', desc = '[F]ind [T]odos',           icon = '' },
    },
  })
end

return M
