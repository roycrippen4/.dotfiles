--- @class KeyPair
--- @field mode? 'n'|'v'|'x'|'s'|'o'|'i'|'l'|'c'
--- @field lhs string
--- @field rhs string|function
--- @field opts? vim.keymap.set.Opts

local function toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

return {
  'mrcjkb/rustaceanvim', -- https://github.com/mrcjkb/rustaceanvim
  version = '^4',
  ft = { 'rust' },
  config = function()
    --- @type KeyPair[]
    local keymaps = {
      { lhs = 'gr', rhs = require('telescope.builtin').lsp_references },
      { lhs = 'gi', rhs = require('telescope.builtin').lsp_implementations },
      { lhs = 'gd', rhs = require('telescope.builtin').lsp_definitions },
      { lhs = '<leader>l!', rhs = '<cmd> RustAnalyzer restart <CR>' },
      { lhs = '<leader>lc', rhs = '<cmd> RustLsp openCargo <CR>' },
      { lhs = '<leader>lC', rhs = '<cmd> RustLsp flyCheck <CR>' },
      { lhs = '<leader>lD', rhs = '<cmd> RustLsp debuggables <CR>' },
      { lhs = '<leader>ld', rhs = toggle_diagnostics },
      { lhs = '<leader>lE', rhs = '<cmd> RustLsp externalDocs <CR>' },
      { lhs = '<leader>le', rhs = '<cmd> RustLsp explainError <CR>' },
      { lhs = '<leader>lM', rhs = '<cmd> RustLsp rebuildProcMacros <CR>' },
      { lhs = '<leader>lm', rhs = '<cmd> RustLsp expandMacro <CR>' },
      { lhs = '<leader>lr', rhs = '<cmd> RustRun <CR>' },
      { lhs = '<leader>lf', rhs = vim.diagnostic.open_float },
      { lhs = '<leader>la', rhs = vim.lsp.buf.code_action },
    }
    require('plugins.lsp.lsp-utils').set_lsp_mappings(keymaps)

    vim.g.rustaceanvim = {
      server = { --- @type RustaceanLspClientOpts
        on_attach = require('plugins.lsp.lsp-utils').on_attach,
      },
      --- @type RustaceanToolsOpts
      tools = {
        float_win_config = {
          border = 'rounded',
        },
      },
    }
  end,
}
