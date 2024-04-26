local map = vim.keymap.set
local builtin = require('telescope.builtin')

local diagnostic_status = true
local function toggle_diagnostics()
  diagnostic_status = not diagnostic_status
  if diagnostic_status then
    vim.api.nvim_echo({ { 'Show diagnostics' } }, false, {})
    vim.diagnostic.enable()
  else
    vim.api.nvim_echo({ { 'Hide diagnostics' } }, false, {})
    vim.diagnostic.disable()
  end
end

map('n', 'gr', builtin.lsp_references, { desc = 'Goto References  ' })
map('n', 'gi', builtin.lsp_implementations, { desc = 'Goto Implementation 󰡱 ' })
map('n', 'gd', builtin.lsp_definitions, { desc = 'Goto Definition 󰼭 ' })
map('n', '<leader>l!', '<cmd> RustAnalyzer restart <CR>', { desc = 'Restart RustAnalyzer  ' })
map('n', '<leader>lc', '<cmd> RustLsp openCargo <CR>', { desc = 'Open Cargo  ' })
map('n', '<leader>lC', '<cmd> RustLsp flyCheck <CR>', { desc = 'Rust run cargo check ' })
map('n', '<leader>lD', '<cmd> RustLsp debuggables <CR>', { desc = 'Debug rust  ' })
map('n', '<leader>ld', toggle_diagnostics, { desc = 'Toggle Diagnostics 󰨚 ' })
map('n', '<leader>lE', '<cmd> RustLsp externalDocs <CR>', { desc = 'Open Rust Documentation 󱔗 ' })
map('n', '<leader>le', '<cmd> RustLsp explainError <CR>', { desc = 'Explain error  ' })
map('n', '<leader>lM', '<cmd> RustLsp rebuildProcMacros <CR>', { desc = 'Rebuild proc macros  ' })
map('n', '<leader>lm', '<cmd> RustLsp expandMacro <CR>', { desc = 'Expand macro  ' })
map('n', '<leader>lr', '<cmd> RustLsp runnables <CR>', { desc = 'Run rust  ' })
map('n', '<leader>lf', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message 󰉪 ' })
map('n', '<leader>r', require('plugins.local.renamer').open, { desc = 'LSP Rename 󰑕 ' })
map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Code Action  ' })
