---@type LazyPluginSpec[]
return {
  {
    'nvzone/minty',
    dependencies = { 'nvzone/volt' },
    cmd = { 'Shades', 'Huefy' },
    keys = {
      { '<leader>cs', '<cmd>Shades<cr>' },
      { '<leader>cp', '<cmd>Huefy<cr>' },
    },
  },
}
