return {
  'zbirenbaum/copilot.lua', -- https://github.com/zbirenbaum/copilot.lua
  event = 'BufReadPost',
  opts = {
    panel = { enabled = false },
    suggestion = { enabled = true, auto_trigger = true, keymap = { accept = '<M-CR>' } },
    copilot_node_command = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v21.6.2/bin/node',
  },
  config = function(_, opts)
    local copilot = require('copilot')
    local autopairs = require('nvim-autopairs')
    local suggestion = require('copilot.suggestion')

    copilot.setup(opts)

    vim.keymap.set('i', '<M-CR>', function()
      autopairs.disable()
      suggestion.accept()
      autopairs.enable()
    end)
  end,
}
