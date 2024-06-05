return {
  'pmizio/typescript-tools.nvim', -- https://github.com/pmizio/typescript-tools.nvim
  ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'svelte' },
  dependencies = {
    'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  },
  config = function()
    local M = require('plugins.lsp.lsp-utils')
    local api = require('typescript-tools.api')
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.capabilities,
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          jsxAttributeCompletionStyle = 'auto',
        },
      },
      handlers = {
        ['textDocument/publishDiagnostics'] = api.filter_diagnostics({ 80001, 80004 }),
      },
    }

    vim.keymap.set('n', 'fi', '<cmd> TSToolsOrganizeImports<CR>', { desc = 'Organize imports' })
    require('typescript-tools').setup(opts)
  end,
}
