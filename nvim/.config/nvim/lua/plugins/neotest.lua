---@module "neotest"

---@type LazyPluginSpec
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('rustaceanvim.neotest'),
      },
      output_panel = { open = 'vsplit | vertical resize 100' },
      status = { virtual_text = true },
      quickfix = { enabled = false },
    })

    local wk = require('which-key')
    wk.add({
      {
        mode = { 'n' },
        { '<leader>ns', '<cmd>Neotest summary<cr>', desc = 'Toggle Neotest Summary', icon = '󰙨' },
        { '<leader>no', '<cmd>Neotest output-panel<cr>', desc = 'Toggle Neotest output-panel', icon = '󰙨' },
      },
    })
  end,
}
