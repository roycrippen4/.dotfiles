local register = require('which-key').register

local diagnostic_status = true
local toggle_diagnostics = function()
  diagnostic_status = not diagnostic_status
  if diagnostic_status then
    vim.api.nvim_echo({ { 'Show diagnostics' } }, false, {})
    vim.diagnostic.enable()
  else
    vim.api.nvim_echo({ { 'Hide diagnostics' } }, false, {})
    vim.diagnostic.disable()
  end
end

register({
  ['gr'] = {
    function()
      require('telescope.builtin').lsp_references()
    end,
    'Goto References  ',
  },

  ['gi'] = {
    function()
      require('telescope.builtin').lsp_implementations()
    end,
    'Goto Implementation 󰡱 ',
  },

  ['gd'] = {
    function()
      require('telescope.builtin').lsp_definitions()
    end,
    'Goto Definition 󰼭 ',
  },

  ['<leader>l!'] = { '<cmd> RustAnalyzer restart <CR>', 'Restart RustAnalyzer  ' },
  ['<leader>lc'] = { '<cmd> RustLsp openCargo <CR>', 'Open Cargo  ' },
  ['<leader>lC'] = { '<cmd> RustLsp flyCheck <CR>', 'Rust run cargo check ' },
  ['<leader>lD'] = { '<cmd> RustLsp debuggables <CR>', 'Debug rust  ' },
  ['<leader>ld'] = { toggle_diagnostics, 'Toggle Diagnostics 󰨚 ' },
  ['<leader>lE'] = { '<cmd> RustLsp externalDocs <CR>', 'Open Rust Documentation 󱔗 ' },
  ['<leader>le'] = { '<cmd> RustLsp explainError <CR>', 'Explain error  ' },
  ['<leader>lM'] = { '<cmd> RustLsp rebuildProcMacros <CR>', 'Rebuild proc macros  ' },
  ['<leader>lm'] = { '<cmd> RustLsp expandMacro <CR>', 'Expand macro  ' },
  ['<leader>lr'] = { '<cmd> RustLsp runnables <CR>', 'Run rust  ' },

  ['<leader>lf'] = {
    function()
      vim.diagnostic.open_float()
    end,
    'Open floating diagnostic message 󰉪 ',
  },
  ['<leader>r'] = {
    function()
      require('plugins.local.renamer').open()
    end,
    'LSP Rename 󰑕 ',
  },

  ['<leader>la'] = {
    function()
      vim.lsp.buf.code_action()
    end,
    'Code Action  ',
  },
})
