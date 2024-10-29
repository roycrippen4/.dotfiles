---@module "copilot"
---@type LazyPluginSpec
return {
  'zbirenbaum/copilot.lua', -- https://github.com/zbirenbaum/copilot.lua
  event = 'BufReadPost',
  ---@type copilot_config
  opts = {
    panel = { enabled = false },
    suggestion = { enabled = true, auto_trigger = true, keymap = { accept = '<M-cr>' } },
    copilot_node_command = vim.fn.expand('$HOME') .. '/.nvm/versions/node/v21.7.3/bin/node',
    filetypes = {
      ocaml = false,
      rust = false,
      zig = false,
    },
  },
}
