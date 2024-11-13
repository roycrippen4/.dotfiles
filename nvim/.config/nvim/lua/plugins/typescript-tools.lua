---@type LazyPluginSpec
return {
  'pmizio/typescript-tools.nvim', -- https://github.com/pmizio/typescript-tools.nvim
  ft = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  dependencies = {
    'nvim-lua/plenary.nvim', -- https://github.com/nvim-lua/plenary.nvim
    'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
    { 'dmmulroy/ts-error-translator.nvim', opts = {} }, -- https://github.com/dmmulroy/ts-error-translator.nvim
  },
  opts = {
    on_attach = require('core.utils').on_attach,
    capabilities = require('core.utils').capabilities,
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
  },
}
