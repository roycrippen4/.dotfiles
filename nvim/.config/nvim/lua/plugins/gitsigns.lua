local icon = '│'

local function blame_full()
  require('gitsigns').blame_line({ full = true })
end

---@type LazyPluginSpec
return {
  'lewis6991/gitsigns.nvim',
  event = 'VimEnter',
  config = function()
    local gitsigns = require('gitsigns')
    local wk = require('which-key')

    gitsigns.setup({
      signs = {
        add = { text = icon },
        change = { text = icon },
        delete = { text = icon },
        topdelete = { text = icon },
        changedelete = { text = icon },
        untracked = { text = icon },
      },
    })

    wk.add({
      {
        mode = 'n',
        { '<leader>gb', gitsigns.blame_line, desc = '[B]lame line', icon = '󱚝' },
        { '<leader>gB', blame_full, desc = '[B]lame line full', icon = '󱚝' },
        { '<leader>gd', gitsigns.diffthis, desc = '[D]iff file', icon = '' },
        { '<leader>gr', gitsigns.reset_buffer, desc = '[R]eset buffer', icon = '' },
        { '<leader>gtb', gitsigns.toggle_current_line_blame, desc = '[T]oggle [b]lame', icon = '󱚝' },
        { '<leader>gs', gitsigns.stage_buffer, desc = '[S]tage buffer', icon = '' },
      },
    })
  end,
}
