return {
  'zbirenbaum/copilot.lua', -- https://github.com/zbirenbaum/copilot.lua
  event = 'BufReadPost',
  opts = {
    panel = { enabled = false },
    suggestion = { enabled = true, auto_trigger = true, keymap = { accept = '<M-cr>' } },
    copilot_node_command = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v21.6.2/bin/node',
  },
  keys = {
    {
      mode = 'i',
      '<M-cr>',
      function()
        require('copilot.suggestion').accept()
      end,
    },
  },
}
