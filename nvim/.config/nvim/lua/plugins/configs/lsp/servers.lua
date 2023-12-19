local mason_opts = require('plugins.configs.lsp.mason')

require('mason').setup(mason_opts)
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
    'docker_compose_language_service',
    'dockerls',
    'emmet_language_server',
    'eslint',
    'gopls',
    'hls',
    'html',
    'htmx',
    'jsonls',
    'lua_ls',
    'marksman',
    'mdx_analyzer',
    'pyright',
    'rust_analyzer',
    'svelte',
    'tailwindcss',
    'taplo',
    'yamlls',
  },
})

local lspconfig = require('lspconfig')
local M = require('plugins.configs.lsp.lspconfig')

local cwd = vim.fn.getcwd(-1, -1)
if cwd ~= nil then
  if string.sub(cwd, -4) then
    require('neodev').setup({})
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

lspconfig['bashls'].setup({
  filetypes = { 'bash', 'sh', 'zsh', 'zshrc' },
  capabilities = capabilities,
  on_attach = M.on_attach,
  root_dir = function()
    return vim.loop.cwd()
  end,
})

lspconfig['clangd'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['cssls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['docker_compose_language_service'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['dockerls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['emmet_language_server'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
})

lspconfig['eslint'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
  settings = {
    workingDirectory = {
      mode = 'auto',
    },
    rulesCustomizations = {
      {
        rule = 'no-unused-vars',
        severity = 'off',
      },
      {
        rule = '@typescript-eslint/no-unused-vars',
        severity = 'off',
      },
    },
  },
})

lspconfig['gopls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['hls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['html'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['htmx'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['jsonls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['lua_ls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
      },
    },
    maxPreload = 100000,
    preloadFileSize = 10000,
  },
})

lspconfig['marksman'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['mdx_analyzer'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['pyright'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['svelte'].setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    M.on_attach(client, bufnr)

    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = { '*.js', '*.ts' },
      callback = function(ctx)
        if client.name == 'svelte' then
          client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
        end
      end,
    })
  end,
})

lspconfig['tailwindcss'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

lspconfig['taplo'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})

local api = require('typescript-tools.api')
require('typescript-tools').setup({
  on_attach = M.on_attach,
  settings = {
    tsserver_plugins = {
      '@styled/typescript-styled-plugin',
    },
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
    ['textDocument/publishDiagnostics'] = api.filter_diagnostics({ 80001 }),
  },
  vim.keymap.set('n', 'fi', '<cmd> TSToolsOrganizeImports<CR>', { desc = 'Organize imports' }),
})

lspconfig['yamlls'].setup({
  capabilities = capabilities,
  on_attach = M.on_attach,
})
